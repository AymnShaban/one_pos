part of '../../basket_imports.dart';

class BasketPosSummary extends StatefulWidget {
  const BasketPosSummary({super.key});

  @override
  State<BasketPosSummary> createState() => _BasketPosSummaryState();
}

class _BasketPosSummaryState extends State<BasketPosSummary> {
  double _discountPercent = 0.0;
  bool _isDiscountAddition =
      false; // true = addition, false = subtraction (discount)
  double _paidAmount = 0.0;
  String _receiptNumber = '';
  String _selectedPaymentMethod = 'Cash';
  CustomerAccountModel? _selectedAccount;
  final List<Map<String, dynamic>> _payments = [];

  Future<void> _openCustomerSearch() async {
    final result = await showDialog<CustomerAccountModel>(
      context: context,
      builder: (_) => const CustomerSearchDialog(),
    );
    if (result != null) {
      setState(() => _selectedAccount = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BaseState<ItemModel>>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

        final totalAmount = state.items.fold<double>(
          0,
          (sum, item) => sum + item.totalSplitPrice,
        );

        final discountAmount = (totalAmount * _discountPercent) / 100;
        final netAmount = _isDiscountAddition
            ? totalAmount + discountAmount
            : totalAmount - discountAmount;

        final totalQuantity = state.items.fold<num>(
          0,
          (sum, item) => sum + item.salesQuantity,
        );

        final itemCount = state.items.length;
        final totalPaid = _payments.fold<double>(
          0,
          (sum, p) => sum + (p['amount'] as double),
        );
        final remainingAmount = netAmount - totalPaid;

        return Container(
          margin: EdgeInsets.all(12.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.isDarkMode ? AppColors.codGray : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountSearch(),
              SizedBox(height: 4.h),
              _buildTotalsSection(totalAmount, netAmount, discountAmount),
              SizedBox(height: 8.h),
              _buildQuantitySection(totalQuantity, itemCount),
              SizedBox(height: 16.h),
              _buildPaymentInputSection(remainingAmount),
              if (_payments.isNotEmpty) ...[
                SizedBox(height: 16.h),
                _buildPaymentsTable(),
              ],
              SizedBox(height: 16.h),
              _buildBalanceSummary(totalPaid, remainingAmount),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountSearch() {
    final isAr = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'new_invoice.to_account'.tr(),
          style: AppTextTheme.labelSmall9Bold,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _openCustomerSearch,
                child: Container(
                  height: 30.h,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.mainAppColor),
                  ),
                  child: Text(
                    _selectedAccount != null
                        ? _selectedAccount!.displayName(isAr)
                        : 'new_invoice.search_account'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _selectedAccount != null
                        ? AppTextTheme.captionBold
                        : AppTextTheme.caption,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: _openCustomerSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealAccentColor,
                minimumSize: Size(80.w, 30.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'common.search'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalsSection(double total, double net, double discountAmount) {
    return Row(
      children: [
        Expanded(
          child: _summaryBox(
            'common.total'.tr().toUpperCase(),
            total.toStringAsFixed(3),
            AppColors.tealAccentColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _summaryBox(
            'new_invoice.net'.tr().toUpperCase(),
            net.toStringAsFixed(3),
            AppColors.mainAppColor,
          ),
        ),

        SizedBox(width: 4.w),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  _radioOption('new_invoice.add'.tr(), true),
                  _radioOption('new_invoice.discount'.tr(), false),
                ],
              ),
              Row(
                children: [
                  Text('%', style: AppTextTheme.captionBold),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _smallInput((val) {
                      setState(
                        () => _discountPercent = double.tryParse(val) ?? 0,
                      );
                    }, _discountPercent.toStringAsFixed(0)),
                  ),
                  Text('=', style: AppTextTheme.captionBold),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _smallValueBox(discountAmount.toStringAsFixed(2), (
                      val,
                    ) {
                      final amount = double.tryParse(val) ?? 0;
                      setState(() {
                        _discountPercent = total > 0
                            ? (amount / total) * 100
                            : 0;
                      });
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySection(num totalQty, int itemCount) {
    return Row(
      children: [
        Expanded(
          child: _columnInfo(
            'new_invoice.total_quantity'.tr(),
            totalQty.toString(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _columnInfo(
            'new_invoice.item_count'.tr(),
            itemCount.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInputSection(double remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _labeledDropdown(
                'new_invoice.payment_method'.tr(),
                ['Cash', 'Visa', 'Bank'],
                (val) {
                  setState(() => _selectedPaymentMethod = val!);
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 1,
              child: _labeledInput(
                'new_invoice.receipt_number'.tr(),
                (val) => _receiptNumber = val,
                '0',
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 1,
              child: _labeledInput(
                'new_invoice.paid'.tr(),
                (val) => _paidAmount = double.tryParse(val) ?? 0,
                remaining.toStringAsFixed(2),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ElevatedButton(
          onPressed: () {
            if (_paidAmount > 0) {
              setState(() {
                _payments.add({
                  'method': _selectedPaymentMethod,
                  'amount': _paidAmount,
                  'receipt': _receiptNumber,
                });
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainAppColor,
            minimumSize: Size(double.infinity, 45.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                'new_invoice.add'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            color: AppColors.mainAppColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'new_invoice.payment_method'.tr(),
                    style: AppTextTheme.labelSmall9Bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    'new_invoice.paid'.tr(),
                    style: AppTextTheme.labelSmall9Bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'new_invoice.receipt_number'.tr(),
                    style: AppTextTheme.labelSmall9Bold,
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(width: 30.w),
              ],
            ),
          ),
          ..._payments.map(
            (p) => Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(p['method'], style: AppTextTheme.caption),
                  ),
                  Expanded(
                    child: Text(
                      p['amount'].toStringAsFixed(2),
                      style: AppTextTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p['receipt'],
                      style: AppTextTheme.caption,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _payments.remove(p)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummary(double paid, double remaining) {
    return Row(
      children: [
        Expanded(
          child: _columnInfo(
            'new_invoice.paid'.tr(),
            paid.toStringAsFixed(3),
            color: Colors.green,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _columnInfo(
            'new_invoice.unpaid'.tr(),
            remaining.toStringAsFixed(3),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _summaryBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextTheme.captionBold.copyWith(color: Colors.white),
          ),
          Text(
            value,
            style: AppTextTheme.captionBold.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String label, bool value) {
    return Row(
      children: [
        Radio<bool>(
          value: value,
          groupValue: _isDiscountAddition,
          onChanged: (val) => setState(() => _isDiscountAddition = val!),
          activeColor: AppColors.mainAppColor,
          visualDensity: VisualDensity.compact,
        ),
        Text(label, style: TextStyle(fontSize: 10.sp)),
      ],
    );
  }

  Widget _smallInput(Function(String) onChanged, String initial) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        style: AppTextTheme.captionBold,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(border: InputBorder.none),
        onChanged: onChanged,
      ),
    );
  }

  Widget _smallValueBox(String value, Function(String) onChanged) {
    return _EditableSmallBox(value: value, onChanged: onChanged);
  }

  Widget _columnInfo(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextTheme.labelSmall9Bold),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextTheme.captionBold,
          ),
        ),
      ],
    );
  }

  Widget _labeledInput(String label, Function(String) onChanged, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            style: AppTextTheme.captionBold,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _labeledDropdown(
    String label,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              style: AppTextTheme.caption,
              value: _selectedPaymentMethod,
              isExpanded: true,
              items: options
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(o, style: AppTextTheme.caption),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Small numeric box that shows an externally-computed [value] but is also
/// editable like a text field. Edits flow through [onChanged]; the displayed
/// value is only re-synced from outside while the field is not focused, so
/// typing isn't interrupted.
class _EditableSmallBox extends StatefulWidget {
  final String value;
  final Function(String) onChanged;

  const _EditableSmallBox({required this.value, required this.onChanged});

  @override
  State<_EditableSmallBox> createState() => _EditableSmallBoxState();
}

class _EditableSmallBoxState extends State<_EditableSmallBox> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _EditableSmallBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reflect the recomputed value only when the user isn't editing.
    if (!_focusNode.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: AppTextTheme.captionBold,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
