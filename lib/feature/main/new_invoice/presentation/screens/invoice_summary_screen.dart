part of '../../new_invoice_imports.dart';

class InvoiceSummaryScreen extends StatefulWidget {
  final Map<String, dynamic>? editInvoice;
  final int invoiceNumber;
  final bool isPriceQuote;

  const InvoiceSummaryScreen({
    super.key,
    this.editInvoice,
    required this.invoiceNumber,
    this.isPriceQuote = false,
  });

  @override
  State<InvoiceSummaryScreen> createState() => _InvoiceSummaryScreenState();
}

class _InvoiceSummaryScreenState extends State<InvoiceSummaryScreen> {
  final _discountPercentController  = TextEditingController(text: '0');
  final _additionPercentController  = TextEditingController(text: '0');
  final _paidController             = TextEditingController();
  final _receiptNumberController    = TextEditingController();

  PaymentWayModel? _selectedPayWay;
  bool _isAdditionMode = false;

  @override
  void dispose() {
    _discountPercentController.dispose();
    _additionPercentController.dispose();
    _paidController.dispose();
    _receiptNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: BlocListener<NewInvoiceBloc, NewInvoiceState>(
        listenWhen: (prev, curr) =>
        prev.submitStatus != curr.submitStatus,
        listener: (context, state) {
          if (state.submitStatus == Status.success) {
            showCustomSnackBar(
                context, 'new_invoice.order_saved_successfully'.tr());
            context.read<CartBloc>().add(const ClearCart());
            Navigator.popUntil(context, (r) => r.isFirst);
          }
          if (state.submitStatus == Status.failure) {
            showCustomSnackBar(
                context, state.errorMessage ?? 'common.error'.tr());
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ── Cart Items Table ──
                  CartItemsTable(
                    items: cartState.items,
                    onPriceEdit: (i, p) => context
                        .read<CartBloc>()
                        .add(UpdateItemPrice(index: i, newPrice: p)),
                    onDiscountEdit: (i, d) => context
                        .read<CartBloc>()
                        .add(UpdateItemDiscount(index: i, discount: d)),
                    onNoteEdit: (i, n) => context
                        .read<CartBloc>()
                        .add(UpdateItemNote(index: i, note: n)),
                    onRemove: (productId) => context
                        .read<CartBloc>()
                        .add(RemoveItemFromCart(productId)),
                  ),
                  SizedBox(height: 16.h),

                  // ── Customer Row ──
                  _CustomerRow(editInvoice: widget.editInvoice),
                  SizedBox(height: 16.h),

                  // ── Totals ──
                  _TotalsSection(
                    cartState:                 cartState,
                    isAdditionMode:            _isAdditionMode,
                    discountPercentController: _discountPercentController,
                    additionPercentController: _additionPercentController,
                    onToggleMode: (val) {
                      setState(() {
                        _isAdditionMode = val;
                        _discountPercentController.text = '0';
                        _additionPercentController.text = '0';
                      });
                      context.read<CartBloc>().add(
                        val
                            ? const UpdateAdditionPercent(0)
                            : const UpdateDiscountPercent(0),
                      );
                    },
                    onDiscountChanged: (p) => context
                        .read<CartBloc>()
                        .add(UpdateDiscountPercent(p)),
                    onAdditionChanged: (p) => context
                        .read<CartBloc>()
                        .add(UpdateAdditionPercent(p)),
                  ),
                  SizedBox(height: 16.h),

                  // ── Summary Fields ──
                  _SummaryFields(cartState: cartState),
                  SizedBox(height: 16.h),

                  // ── Payment Section ──
                  PaymentSection(
                    payWays: context
                        .read<NewInvoiceBloc>()
                        .state
                        .payWaysState
                        .items,
                    selectedPayWay:    _selectedPayWay,
                    paidController:    _paidController,
                    receiptController: _receiptNumberController,
                    receipts:          cartState.receipts,
                    totalDue:          cartState.totalAfterAdjustments,
                    onPayWayChanged: (pw) {
                      setState(() => _selectedPayWay = pw);
                      if (pw != null && pw.isCash) {
                        _paidController.text = cartState
                            .totalAfterAdjustments
                            .toStringAsFixed(2);
                      } else {
                        _paidController.clear();
                      }
                    },
                    onAddReceipt: () {
                      if (_selectedPayWay == null ||
                          _paidController.text.isEmpty) {
                        showCustomSnackBar(
                          context,
                          'new_invoice.enter_payment_method_and_amount'.tr(),
                        );
                        return;
                      }
                      context.read<CartBloc>().add(
                        AddPayReceipt(
                          PayReceiptModel(
                            payingValue:   double.parse(_paidController.text),
                            payingType:    _selectedPayWay!.code,
                            receiptNumber: _receiptNumberController.text,
                            payWayName:    _selectedPayWay!.nameAr,
                            payWayEnName:  _selectedPayWay!.nameEn,
                          ),
                        ),
                      );
                      _paidController.clear();
                      _receiptNumberController.clear();
                    },
                    onRemoveReceipt: (i) => context
                        .read<CartBloc>()
                        .add(RemovePayReceipt(i)),
                  ),
                  SizedBox(height: 24.h),

                  // ── Submit ──
                  _SubmitButton(
                    isEdit:      widget.editInvoice != null,
                    hasReceipts: cartState.receipts.isNotEmpty,
                    onTap: () => _submit(context, cartState),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.mainAppColor,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: AppColors.white),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${'new_invoice.invoice_number'.tr()} ${widget.invoiceNumber}',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'new_invoice.total'.tr(),
            style: AppTextTheme.caption.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context, CartState cartState) {
    if (cartState.receipts.isEmpty) return;

    final invoiceBloc = context.read<NewInvoiceBloc>();
    final state       = invoiceBloc.state;

    if (widget.editInvoice != null) {
      invoiceBloc.add(
        EditInvoice(
          EditInvoiceRequest(
            invoiceId:       widget.editInvoice!['InvoiceID'],
            invoiceNo:       widget.editInvoice!['InvoiceNo'].toString(),
            invoiceDate:     widget.editInvoice!['InvoiceDate'],
            companyBranchId: state.branchId == 0
                ? widget.editInvoice!['CompanyBranchID']
                : state.branchId,
            payingType:      widget.editInvoice!['PayingType'],
            remainder:       cartState.remaining,
            currencyId:      state.currencyId,
            currencyRate:    state.currencyRate,
            customerId:      widget.editInvoice!['CustomerID'],
            totalValue:      cartState.subtotal,
            totalDiscount:   cartState.discountAmount,
            totalAddition:   cartState.additionAmount,
            finalValue:      cartState.totalAfterAdjustments,
            items:           cartState.items,
            payWays:         cartState.receipts,
          ),
        ),
      );
    } else {
      invoiceBloc.add(
        SubmitInvoice(
          CreateInvoiceRequest(
            invoicePatternId: state.patternId,
            invoiceDate: DateFormat('yyyy/MM/dd', 'en_US').format(DateTime.now()),
            companyBranchId:  state.branchId,
            remainder:        cartState.remaining,
            currencyId:       state.currencyId,
            currencyRate:     state.currencyRate,
            totalValue:       cartState.subtotal,
            totalDiscount:    cartState.discountAmount,
            totalAddition:    cartState.additionAmount,
            finalValue:       cartState.totalAfterAdjustments,
            payingType:       cartState.receipts.first.payingType,
            items:            cartState.items,
            payWays:          cartState.receipts,
          ),
        ),
      );
    }
  }
}

// ── Totals Section ────────────────────────────────────────────────────────────
class _TotalsSection extends StatelessWidget {
  final CartState cartState;
  final bool isAdditionMode;
  final TextEditingController discountPercentController;
  final TextEditingController additionPercentController;
  final ValueChanged<bool> onToggleMode;
  final ValueChanged<double> onDiscountChanged;
  final ValueChanged<double> onAdditionChanged;

  const _TotalsSection({
    required this.cartState,
    required this.isAdditionMode,
    required this.discountPercentController,
    required this.additionPercentController,
    required this.onToggleMode,
    required this.onDiscountChanged,
    required this.onAdditionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AmountBadge(
                value: cartState.subtotal.toStringAsFixed(2),
                color: AppColors.secondaryColor,
              ),
              Text(
                'new_invoice.total'.tr(),
                style: AppTextTheme.body2Bold.copyWith(color: AppColors.black),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Discount / Addition toggle + input
          Row(
            children: [
              // Toggle
              Row(
                children: [
                  _RadioToggle(
                    label:    'new_invoice.discount'.tr(),
                    selected: !isAdditionMode,
                    onTap:    () => onToggleMode(false),
                  ),
                  SizedBox(width: 12.w),
                  _RadioToggle(
                    label:    'new_invoice.add'.tr(),
                    selected: isAdditionMode,
                    onTap:    () => onToggleMode(true),
                  ),
                ],
              ),
              SizedBox(width: 10.w),

              // Percent field
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '%',
                      style: AppTextTheme.body2Bold
                          .copyWith(color: AppColors.black),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: TextField(
                        controller: isAdditionMode
                            ? additionPercentController
                            : discountPercentController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.caption
                            .copyWith(color: AppColors.black),
                        onChanged: (v) {
                          final p = double.tryParse(v) ?? 0;
                          isAdditionMode
                              ? onAdditionChanged(p)
                              : onDiscountChanged(p);
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 8.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                                color: AppColors.mainAppColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                                color: AppColors.mainAppColor, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Net row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AmountBadge(
                value: cartState.totalAfterAdjustments.toStringAsFixed(2),
                color: AppColors.mainAppColor,
              ),
              Text(
                'new_invoice.net'.tr(),
                style: AppTextTheme.body2Bold.copyWith(color: AppColors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountBadge extends StatelessWidget {
  final String value;
  final Color color;

  const _AmountBadge({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        value,
        style: AppTextTheme.body2Bold.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _RadioToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.mainAppColor, width: 2),
              color: selected
                  ? AppColors.mainAppColor
                  : Colors.transparent,
            ),
            child: selected
                ? Icon(Icons.check,
                color: AppColors.white, size: 11.sp)
                : null,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style:
            AppTextTheme.caption.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }
}

// ── Summary Fields ────────────────────────────────────────────────────────────
class _SummaryFields extends StatelessWidget {
  final CartState cartState;

  const _SummaryFields({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            items: [
              (
              label: 'new_invoice.paid'.tr(),
              value: cartState.totalPaid.toStringAsFixed(2),
              ),
              (
              label: 'new_invoice.unpaid'.tr(),
              value: cartState.remaining.toStringAsFixed(2),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _SummaryCard(
            items: [
              (
              label: 'new_invoice.total_quantity'.tr(),
              value: '${cartState.totalQuantity}',
              ),
              (
              label: 'new_invoice.item_count'.tr(),
              value: '${cartState.activeItems.length}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<({String label, String value})> items;

  const _SummaryCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.mainAppColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.value,
                  style: AppTextTheme.body2Bold
                      .copyWith(color: AppColors.black),
                ),
                Text(
                  item.label,
                  style: AppTextTheme.caption
                      .copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

// ── Customer Row ──────────────────────────────────────────────────────────────
class _CustomerRow extends StatelessWidget {
  final Map<String, dynamic>? editInvoice;

  const _CustomerRow({this.editInvoice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            // TODO: Navigate to customer search screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainAppColor.withValues(alpha: 0.1),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          ),
          child: Text(
            'common.search'.tr(),
            style: AppTextTheme.caption
                .copyWith(color: AppColors.mainAppColor),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'new_invoice.to_account'.tr(),
                style:
                AppTextTheme.caption.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: 4.h),
              Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    editInvoice != null
                        ? '${editInvoice!['CustomerName']}'
                        : 'new_invoice.search_account'.tr(),
                    style: AppTextTheme.caption
                        .copyWith(color: AppColors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Submit Button ─────────────────────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final bool isEdit;
  final bool hasReceipts;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.isEdit,
    required this.hasReceipts,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<NewInvoiceBloc>().state.submitStatus ==
        Status.loading;

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: hasReceipts && !isLoading ? onTap : null,
        icon: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            color: AppColors.white,
            strokeWidth: 2,
          ),
        )
            : Icon(
          isEdit ? Icons.edit_rounded : Icons.save_rounded,
          color: AppColors.white,
        ),
        label: Text(
          isEdit ? 'new_invoice.edit'.tr() : 'new_invoice.save'.tr(),
          style: AppTextTheme.body2Bold.copyWith(color: AppColors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: hasReceipts
              ? AppColors.mainAppColor
              : AppColors.mainAppColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
      ),
    );
  }
}