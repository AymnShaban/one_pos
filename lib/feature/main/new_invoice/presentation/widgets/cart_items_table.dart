part of '../../new_invoice_imports.dart';

class CartItemsTable extends StatelessWidget {
  final List<CartItemModel> items;
  final void Function(int index, double price)   onPriceEdit;
  final void Function(int index, num discount)   onDiscountEdit;
  final void Function(int index, String note)    onNoteEdit;
  final void Function(int productId)             onRemove;

  const CartItemsTable({
    super.key,
    required this.items,
    required this.onPriceEdit,
    required this.onDiscountEdit,
    required this.onNoteEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final active = items.where((i) => i.rowState != 'D').toList();
    if (active.isEmpty) return const SizedBox();

    return Container(
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
          // ── Header ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              children: [
                _HeaderCell('new_invoice.item'.tr(),             flex: 3),
                _HeaderCell('new_invoice.discount_percent'.tr(), flex: 2),
                _HeaderCell('new_invoice.quantity'.tr(),         flex: 1),
                _HeaderCell('new_invoice.price'.tr(),            flex: 2),
                _HeaderCell('new_invoice.total'.tr(),            flex: 2),
                _HeaderCell('new_invoice.balance'.tr(),          flex: 2),
                SizedBox(width: 24.w),
              ],
            ),
          ),

          // ── Rows ──
          ...active.asMap().entries.map((entry) {
            final i    = entry.key;
            final item = entry.value;
            return Column(
              children: [
                _CartRow(
                  item:           item,
                  index:          i,
                  onPriceEdit:    onPriceEdit,
                  onDiscountEdit: onDiscountEdit,
                  onNoteEdit:     onNoteEdit,
                  onRemove:       () => onRemove(item.productId),
                ),
                if (i != active.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.backgroundColor,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Header Cell ───────────────────────────────────────────────────────────────
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextTheme.labelSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ── Cart Row ──────────────────────────────────────────────────────────────────
class _CartRow extends StatelessWidget {
  final CartItemModel item;
  final int index;
  final void Function(int, double) onPriceEdit;
  final void Function(int, num)    onDiscountEdit;
  final void Function(int, String) onNoteEdit;
  final VoidCallback               onRemove;

  const _CartRow({
    required this.item,
    required this.index,
    required this.onPriceEdit,
    required this.onDiscountEdit,
    required this.onNoteEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('cart_${item.productId}_$index'),
      background: Container(
        color: AppColors.redBg,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.w),
        child: Icon(Icons.delete_outline, color: AppColors.red),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            // Name — tap for note
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () =>
                    _showNoteDialog(context, item.notes, index),
                child: Text(
                  item.productArName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.labelMedium11
                      .copyWith(color: AppColors.black),
                ),
              ),
            ),

            // Discount — tap to edit
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _showDiscountDialog(
                    context, item.discountPercent, index),
                child: Text(
                  '${item.discountPercent}%',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.labelSmall
                      .copyWith(color: AppColors.red),
                ),
              ),
            ),

            // Quantity
            Expanded(
              flex: 1,
              child: Text(
                item.quantity % 1 == 0
                    ? '${item.quantity.toInt()}'
                    : item.quantity.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall
                    .copyWith(color: AppColors.black),
              ),
            ),

            // Price — tap to edit
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () =>
                    _showPriceDialog(context, item.price, index),
                child: Text(
                  item.price.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: AppTextTheme.labelSmall.copyWith(
                    color: AppColors.mainAppColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            // Line total
            Expanded(
              flex: 2,
              child: Text(
                item.lineTotal.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall
                    .copyWith(color: AppColors.black),
              ),
            ),

            // Stock
            Expanded(
              flex: 2,
              child: Text(
                '${item.stockQuantity}',
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall
                    .copyWith(color: AppColors.grey),
              ),
            ),

            // Delete button
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                color: AppColors.red,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────
  void _showPriceDialog(
      BuildContext context, double current, int idx) {
    final ctrl = TextEditingController(text: current.toString());
    showDialog(
      context: context,
      builder: (_) => _EditDialog(
        title: 'new_invoice.edit_item_price'.tr(),
        controller: ctrl,
        onConfirm: () {
          final v = double.tryParse(ctrl.text);
          if (v != null) onPriceEdit(idx, v);
        },
      ),
    );
  }

  void _showDiscountDialog(
      BuildContext context, num current, int idx) {
    final ctrl = TextEditingController(text: current.toString());
    showDialog(
      context: context,
      builder: (_) => _EditDialog(
        title:      'new_invoice.edit_discount_percent'.tr(),
        controller: ctrl,
        suffix:     '%',
        onConfirm: () {
          final v = num.tryParse(ctrl.text);
          if (v != null) onDiscountEdit(idx, v);
        },
      ),
    );
  }

  void _showNoteDialog(
      BuildContext context, String current, int idx) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (_) => _EditDialog(
        title:      'new_invoice.add_note'.tr(),
        controller: ctrl,
        isText:     true,
        onConfirm:  () => onNoteEdit(idx, ctrl.text),
      ),
    );
  }
}

// ── Edit Dialog ───────────────────────────────────────────────────────────────
class _EditDialog extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? suffix;
  final bool isText;
  final VoidCallback onConfirm;

  const _EditDialog({
    required this.title,
    required this.controller,
    required this.onConfirm,
    this.suffix,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r)),
      title: Text(title,
          style: AppTextTheme.body2Bold.copyWith(color: AppColors.black)),
      content: TextField(
        controller: controller,
        keyboardType:
        isText ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          suffixText: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide:
            BorderSide(color: AppColors.mainAppColor, width: 2),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.mainAppColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text(
                  'common.cancel'.tr(),
                  style: AppTextTheme.caption
                      .copyWith(color: AppColors.mainAppColor),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAppColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  elevation: 0,
                ),
                child: Text(
                  'common.confirm'.tr(),
                  style: AppTextTheme.caption
                      .copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}