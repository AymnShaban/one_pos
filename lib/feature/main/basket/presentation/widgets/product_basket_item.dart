part of '../../basket_imports.dart';

/// Blue column-header row shown once above the basket list.
class BasketTableHeader extends StatelessWidget {
  const BasketTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainAppColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          _headerCell('item'.tr(), flex: 3, align: TextAlign.start),
          _headerCell('discount_percentage'.tr(), flex: 2),
          _headerCell('quantity'.tr(), flex: 1),
          _headerCell('price'.tr(), flex: 2),
          _headerCell('total'.tr(), flex: 2),
          _headerCell('balance'.tr(), flex: 2),
          _headerCell('expiry'.tr(), flex: 2),
        ],
      ),
    );
  }

  Widget _headerCell(String text,
      {required int flex, TextAlign align = TextAlign.center}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextTheme.caption.copyWith(
          color: AppColors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProductBasketItem extends StatefulWidget {
  final ItemModel item;
  final BasketBloc bloc;

  const ProductBasketItem({super.key, required this.item, required this.bloc});

  @override
  State<ProductBasketItem> createState() => _ProductBasketItemState();
}

class _ProductBasketItemState extends State<ProductBasketItem> {
  bool _isProcessing = false;

  Future<void> _showQuantityDialog({required bool isFromDecrement}) async {
    final title = isFromDecrement
        ? 'Quantity is high. Enter the desired total quantity:'.tr()
        : 'Quantity is getting high. Enter the desired total quantity:'.tr();

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        final controller = TextEditingController(
          text: '${widget.item.salesQuantity}',
        );
        return AlertDialog(
          backgroundColor: context.isDarkMode
              ? AppColors.codGray
              : AppColors.backgroundColor,
          title: Text(title, style: AppTextTheme.bodySmall),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Total number of items'.tr(),
              hintStyle: AppTextTheme.captionBold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: Text('Set'.tr()),
            ),
          ],
        );
      },
    );

    if (result != null) {
      final newTotal = int.tryParse(result) ?? -1;
      if (newTotal >= 0) {
        final customerModel = getIt<IUserCache>().getUserModel();
        if (customerModel == null) return;

        final diff = newTotal - widget.item.salesQuantity;

        // Use the new single-call set logic instead of looping.
        if (diff != 0) {
          setState(() => _isProcessing = true);
          
          context.read<AddToBasketBloc>().add(
            AddToBasket(
              AddToBasketRequest(
                customerID: customerModel.id,
                productID: widget.item.productId,
                productBarcode: widget.item.barCode,
                item: widget.item,
                quantity: newTotal,
              ),
            ),
          );

          // Refresh basket to update the counter
          if (mounted) {
            context.read<BasketBloc>().add(const FetchBasketItems());
          }
        }
      }
    }
  }

  Future<void> _deleteAllQuantity() async {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) return;

    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    context.read<AddToBasketBloc>().add(
      AddToBasket(
        AddToBasketRequest(
          customerID: customerModel.id,
          productID: widget.item.productId,
          productBarcode: widget.item.barCode,
          item: widget.item,
          quantity: 0, // 0 removes the item
        ),
      ),
    );

    // Refresh basket to update the counter
    context.read<BasketBloc>().add(const FetchBasketItems());
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final item = widget.item;
    final name = isAr ? item.productArName : item.productEnName;
    final discountPct = item.offerPercentage ?? 0;

    return MultiBlocListener(
      listeners: [
        BlocListener<BasketBloc, BaseState<ItemModel>>(
          listener: (context, state) {
            if (state.status == Status.success ||
                state.status == Status.failure) {
              if (mounted) setState(() => _isProcessing = false);
            }
          },
        ),
        BlocListener<AddToBasketBloc, BaseState<void>>(
          listener: (context, state) {
            if (state.status == Status.success ||
                state.status == Status.failure) {
              if (mounted) setState(() => _isProcessing = false);
            }
          },
        ),
      ],
      child: Dismissible(
        key: ValueKey(item.productId),
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart ||
              direction == DismissDirection.startToEnd) {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text(
                    'confirm_delete'.tr(),
                    style: AppTextTheme.bodySmall,
                  ),
                  content: Text(
                    'are_you_sure_you_want_to_delete_this_item'.tr(),
                    style: AppTextTheme.captionBold,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, false);
                        if (mounted) {
                          context.read<BasketBloc>().add(
                            const FetchBasketItems(),
                          );
                        }
                      },
                      child: Text('cancel'.tr()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text('delete'.tr()),
                    ),
                  ],
                );
              },
            );

            if (confirmed == true) {
              await _deleteAllQuantity();
            } else {
              // Refresh if canceled to reset the dismissible state
              if (context.mounted) {
                context.read<BasketBloc>().add(const FetchBasketItems());
              }
            }
          }
        },
        child: InkWell(
          onTap: _isProcessing
              ? null
              : () => _showQuantityDialog(isFromDecrement: false),
          child: Opacity(
            opacity: _isProcessing ? 0.5 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: context.isDarkMode ? AppColors.codGray : Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(
                children: [
                  _cell(name, flex: 3, align: TextAlign.start, bold: true),
                  _cell(
                    '${discountPct.toStringAsFixed(0)}%',
                    flex: 2,
                    color: AppColors.red,
                  ),
                  _cell('${item.salesQuantity}', flex: 1),
                  _cell(item.price.toStringAsFixed(2), flex: 2),
                  _cell(item.totalSplitPrice.toStringAsFixed(3), flex: 2),
                  _cell(item.stockQuantity.toStringAsFixed(0), flex: 2),
                  _cell('-', flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(
    String text, {
    required int flex,
    TextAlign align = TextAlign.center,
    Color? color,
    bool bold = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextTheme.caption.copyWith(
          fontSize: 11.sp,
          color: color ??
              (context.isDarkMode ? AppColors.white : AppColors.black),
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
