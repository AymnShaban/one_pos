part of '../../new_invoice_imports.dart';

/// Read-only invoice details view, opened after a successful sale (or from any
/// invoice list) with the `invoiceId` / `invoiceNo` returned by the API.
/// Mirrors the printed-invoice layout: header, customer, items, payments,
/// discounts/additions, totals and footer metadata.
class InvoiceDetailsScreen extends StatelessWidget {
  final int invoiceId;
  final int invoiceNo;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoiceId,
    required this.invoiceNo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<InvoiceDetailsBloc>()
        ..add(LoadInvoiceDetails(invoiceId: invoiceId, invoiceNo: invoiceNo)),
      child: _InvoiceDetailsView(invoiceNo: invoiceNo),
    );
  }
}

class _InvoiceDetailsView extends StatelessWidget {
  final int invoiceNo;

  const _InvoiceDetailsView({required this.invoiceNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'invoice_details.title'.tr(),
          style: AppTextTheme.titleSmallBold.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.print_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<InvoiceDetailsBloc, BaseState<InvoiceDetailsModel>>(
        builder: (context, state) {
          if (state.status == Status.loading || state.status == Status.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == Status.failure || state.data == null) {
            return _ErrorView(
              message: state.errorMessage ?? 'common.error'.tr(),
              onRetry: () => context.read<InvoiceDetailsBloc>().add(
                    LoadInvoiceDetails(
                      invoiceId: state.data?.invoiceId ?? 0,
                      invoiceNo: invoiceNo,
                    ),
                  ),
            );
          }
          return _InvoiceBody(invoice: state.data!);
        },
      ),
    );
  }
}

class _InvoiceBody extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _InvoiceBody({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderCard(invoice: invoice),
          SizedBox(height: 12.h),
          _CustomerCard(invoice: invoice),
          SizedBox(height: 12.h),
          _ItemsSection(invoice: invoice),
          SizedBox(height: 12.h),
          _PaymentsSection(invoice: invoice),
          SizedBox(height: 12.h),
          _DiscountsSection(invoice: invoice),
          SizedBox(height: 12.h),
          _TotalsCard(invoice: invoice),
          SizedBox(height: 12.h),
          _FooterBar(invoice: invoice),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────
class _HeaderCard extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _HeaderCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final date = invoice.invoiceDate != null
        ? DateFormat('yyyy/MM/dd — HH:mm', 'en_US').format(invoice.invoiceDate!)
        : '';
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge + date on the left
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Badge(
                label: _invoiceTypeLabel(invoice.invoiceTypeId),
                color: AppColors.tealAccentColor,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14.sp, color: AppColors.grey),
                  SizedBox(width: 6.w),
                  Text(date,
                      style: AppTextTheme.labelSmall
                          .copyWith(color: AppColors.grey)),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Invoice number on the right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('invoice_details.invoice_number'.tr(),
                  style:
                      AppTextTheme.caption.copyWith(color: AppColors.grey)),
              SizedBox(height: 4.h),
              Text('#${invoice.invoiceNo}',
                  style: AppTextTheme.titleLargeBold
                      .copyWith(color: AppColors.mainAppColor)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Customer / store ─────────────────────────────────────────────────────────
class _CustomerCard extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _CustomerCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final storeName =
        invoice.items.isNotEmpty ? invoice.items.first.storeName : null;
    return _Card(
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.mainAppColor.withValues(alpha: 0.1),
            child: Icon(Icons.person_outline,
                color: AppColors.mainAppColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _LabeledValue(
              label: 'invoice_details.customer'.tr(),
              value: invoice.customerName?.trim().isNotEmpty == true
                  ? invoice.customerName!
                  : '-',
              alignEnd: false,
            ),
          ),
          if (storeName?.trim().isNotEmpty == true)
            _LabeledValue(
              label: 'invoice_details.store'.tr(),
              value: storeName!,
              alignEnd: true,
            ),
        ],
      ),
    );
  }
}

// ── Items ─────────────────────────────────────────────────────────────────────
class _ItemsSection extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _ItemsSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          icon: Icons.inventory_2_outlined,
          title: 'invoice_details.items'.tr(),
          trailing: 'invoice_details.items_count'
              .tr(args: ['${invoice.items.length}']),
        ),
        SizedBox(height: 8.h),
        ...invoice.items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _ItemCard(item: item, isAr: isAr, symbol: invoice.symbol),
          ),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final InvoiceDetailsItem item;
  final bool isAr;
  final String symbol;

  const _ItemCard({
    required this.item,
    required this.isAr,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MoneyChip(
                value: item.totalValue,
                symbol: symbol,
                color: AppColors.mainAppColor,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  item.displayName(isAr),
                  textAlign: TextAlign.end,
                  style: AppTextTheme.body2Bold.copyWith(color: AppColors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            [
              if (item.productCode?.isNotEmpty == true)
                '${'invoice_details.code'.tr()}: ${item.productCode}',
              if (item.barCode?.isNotEmpty == true)
                '${'invoice_details.barcode'.tr()}: ${item.barCode}',
            ].join('  •  '),
            textAlign: TextAlign.end,
            style: AppTextTheme.labelSmall.copyWith(color: AppColors.grey),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'invoice_details.quantity'.tr(),
                  value: item.unitName?.isNotEmpty == true
                      ? '${_num(item.quantity)} ${item.unitName}'
                      : _num(item.quantity),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatBox(
                  label: 'invoice_details.price'.tr(),
                  value: _money(item.price),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatBox(
                  label: 'invoice_details.discount'.tr(),
                  value: _money(item.discount),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Payments ────────────────────────────────────────────────────────────────
class _PaymentsSection extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _PaymentsSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          icon: Icons.payments_outlined,
          title: 'invoice_details.payment_methods'.tr(),
        ),
        SizedBox(height: 8.h),
        _Card(
          child: Column(
            children: invoice.payWays.map((p) {
              final name = _payWayLabel(p, isAr);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Text(
                      _money(p.localValue, symbol: invoice.symbol),
                      style: AppTextTheme.body2Bold
                          .copyWith(color: AppColors.green),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(name,
                            style: AppTextTheme.body2Bold
                                .copyWith(color: AppColors.black)),
                        SizedBox(height: 2.h),
                        Text(
                          '${'invoice_details.rate'.tr()} ${_num(p.rate)}',
                          style: AppTextTheme.labelSmall
                              .copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.credit_card,
                        size: 20.sp, color: AppColors.mainAppColor),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Discounts / additions ─────────────────────────────────────────────────────
class _DiscountsSection extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _DiscountsSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          icon: Icons.discount_outlined,
          title: 'invoice_details.discounts_additions'.tr(),
        ),
        SizedBox(height: 8.h),
        if (invoice.discounts.isEmpty)
          DottedEmptyBox(text: 'invoice_details.no_discounts'.tr())
        else
          _Card(
            child: Column(
              children: invoice.discounts.map((d) {
                final name = isAr
                    ? (d.accountArName ?? d.accountEnName ?? '-')
                    : (d.accountEnName ?? d.accountArName ?? '-');
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'invoice_details.discount'.tr()}: ${_money(d.discount)}   '
                            '${'invoice_details.add'.tr()}: ${_money(d.addation)}',
                            style: AppTextTheme.labelSmall
                                .copyWith(color: AppColors.grey),
                          ),
                          Text(name,
                              style: AppTextTheme.body2Bold
                                  .copyWith(color: AppColors.black)),
                        ],
                      ),
                      if (d.notes?.trim().isNotEmpty == true)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            d.notes!,
                            textAlign: TextAlign.end,
                            style: AppTextTheme.labelSmall
                                .copyWith(color: AppColors.grey),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

// ── Totals ─────────────────────────────────────────────────────────────────────
class _TotalsCard extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _TotalsCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          _TotalRow(
            label: 'invoice_details.total'.tr(),
            value: _money(invoice.totalValue),
          ),
          SizedBox(height: 6.h),
          _TotalRow(
            label: 'invoice_details.total_discount'.tr(),
            value: _money(invoice.totalDiscount),
          ),
          SizedBox(height: 6.h),
          _TotalRow(
            label: 'invoice_details.total_addition'.tr(),
            value: _money(invoice.totalAddition),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.3)),
          ),
          _TotalRow(
            label: 'invoice_details.final_value'.tr(),
            value: _money(invoice.finalValue, symbol: invoice.symbol),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

// ── Footer ─────────────────────────────────────────────────────────────────────
class _FooterBar extends StatelessWidget {
  final InvoiceDetailsModel invoice;

  const _FooterBar({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final branch = invoice.companyBranchName?.trim().isNotEmpty == true
        ? invoice.companyBranchName!
        : '${'invoice_details.branch'.tr()} ${invoice.companyBranchId ?? '-'}';
    final parts = [
      if (invoice.createdBy?.trim().isNotEmpty == true)
        '${'invoice_details.created_by'.tr()} ${invoice.createdBy}',
      branch,
      invoice.taxBill
          ? 'invoice_details.taxable'.tr()
          : 'invoice_details.non_taxable'.tr(),
    ];
    return Text(
      parts.join('  •  '),
      textAlign: TextAlign.center,
      style: AppTextTheme.labelSmall.copyWith(color: AppColors.grey),
    );
  }
}

// ── Shared small widgets ────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;

  const _SectionHeader({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.mainAppColor),
        SizedBox(width: 8.w),
        Text(title,
            style: AppTextTheme.body2Bold.copyWith(color: AppColors.black)),
        const Spacer(),
        if (trailing != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(trailing!,
                style: AppTextTheme.labelSmall
                    .copyWith(color: AppColors.mainAppColor)),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(label,
          style: AppTextTheme.labelSmall.copyWith(
              color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _LabeledValue({
    required this.label,
    required this.value,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextTheme.labelSmall.copyWith(color: AppColors.grey)),
        SizedBox(height: 2.h),
        Text(value,
            style: AppTextTheme.body2Bold.copyWith(color: AppColors.black)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  AppTextTheme.labelMedium11Bold.copyWith(color: Colors.white)),
          SizedBox(height: 2.h),
          Text(label,
              style: AppTextTheme.labelSmall
                  .copyWith(color: Colors.white.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _MoneyChip extends StatelessWidget {
  final double value;
  final String symbol;
  final Color color;

  const _MoneyChip({
    required this.value,
    required this.symbol,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text('${_num(value)} $symbol',
          style: AppTextTheme.captionBold.copyWith(color: color)),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _TotalRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = highlight
        ? AppTextTheme.body1Bold.copyWith(color: AppColors.mainAppColor)
        : AppTextTheme.caption.copyWith(color: AppColors.black);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: style),
        Text(label, style: style),
      ],
    );
  }
}

class DottedEmptyBox extends StatelessWidget {
  final String text;

  const DottedEmptyBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.4),
          style: BorderStyle.solid,
        ),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: AppTextTheme.caption.copyWith(color: AppColors.grey)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40.sp, color: AppColors.red),
          SizedBox(height: 12.h),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTextTheme.caption.copyWith(color: AppColors.red)),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('common.retry'.tr()),
          ),
        ],
      ),
    );
  }
}

// ── Formatting helpers ────────────────────────────────────────────────────────
String _money(double v, {String? symbol}) =>
    symbol != null ? '${v.toStringAsFixed(3)} $symbol' : v.toStringAsFixed(3);

String _num(num v) {
  if (v == v.roundToDouble()) return v.toInt().toString();
  return v.toString();
}

String _invoiceTypeLabel(int? typeId) {
  switch (typeId) {
    case 2:
      return 'invoice_details.type_sales'.tr();
    default:
      return 'invoice_details.type_invoice'.tr();
  }
}

String _payWayLabel(InvoiceDetailsPayWay p, bool isAr) {
  final name = isAr ? p.payWayName : p.payWayEnName;
  if (name?.trim().isNotEmpty == true) return name!;
  // Fall back to the payingType enum: 0 → cash.
  switch (p.payingType) {
    case 0:
      return 'invoice_details.cash'.tr();
    default:
      return 'invoice_details.deferred'.tr();
  }
}

extension _InvoiceSymbol on InvoiceDetailsModel {
  /// Currency symbol from the API when populated, otherwise KWD default.
  String get symbol => currencySymbol?.trim().isNotEmpty == true
      ? currencySymbol!
      : 'invoice_details.currency_default'.tr();
}
