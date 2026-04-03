part of '../../basket_imports.dart';

class ProductBasketItem extends StatefulWidget {
  final BasketItemModel item;
  final BasketBloc bloc;

  const ProductBasketItem({super.key, required this.item, required this.bloc});

  @override
  State<ProductBasketItem> createState() => _ProductBasketItemState();
}

class _ProductBasketItemState extends State<ProductBasketItem> {
  bool _isProcessing = false;

  void _incrementQuantity(String barcode) async {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      return;
    }

    if (widget.item.salesQuantity >= 10) {
      await _showQuantityDialog(isFromDecrement: false);
    } else {
      if (_isProcessing) return;
      setState(() => _isProcessing = true);
      context.read<AddToBasketBloc>().add(
        AddToBasket(
          AddToBasketRequest(
            customerID: customerModel.customerId,
            productID: widget.item.productID,
            productBarcode: barcode,
          ),
        ),
      );
      // Refresh basket to update the counter
      context.read<BasketBloc>().add(const FetchBasketItems());
    }
  }

  bool get _hasDiscount => widget.item.priceAfterDiscount > widget.item.price;

  void _decrementQuantity(String barcode) async {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      return;
    }

    if (widget.item.salesQuantity > 15) {
      await _showQuantityDialog(isFromDecrement: true);
    } else {
      if (_isProcessing) return;
      if (widget.item.salesQuantity > 0) {
        setState(() => _isProcessing = true);
        context.read<BasketBloc>().add(
          DeleteBasketItem(widget.item.productID, barcode.toString()),
        );
        // Refresh basket to update the counter
        context.read<BasketBloc>().add(const FetchBasketItems());
      }
    }
  }

  Future<void> _showQuantityDialog({required bool isFromDecrement}) async {
    final title = isFromDecrement
        ? 'Quantity is high. Enter the desired total quantity:'.tr()
        : 'Quantity is getting high. Enter the desired total quantity:'.tr();

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        final controller = TextEditingController();
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

        // Handle both increasing and decreasing
        if (diff != 0) {
          setState(() => _isProcessing = true);
          final isIncreasing = diff > 0;
          final iterations = diff.abs();

          for (int i = 0; i < iterations; i++) {
            if (isIncreasing) {
              // Adding to basket
              if (mounted) {
                context.read<AddToBasketBloc>().add(
                  AddToBasket(
                    AddToBasketRequest(
                      customerID: customerModel.customerId,
                      productID: widget.item.productID,
                      productBarcode: widget.item.barCode,
                    ),
                  ),
                );
              }
            } else {
              // Removing from basket
              if (mounted) {
                context.read<BasketBloc>().add(
                  DeleteBasketItem(widget.item.productID, widget.item.barCode),
                );
              }
            }
          }

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

    for (int i = 0; i < widget.item.salesQuantity; i++) {
      if (mounted) {
        context.read<BasketBloc>().add(
          DeleteBasketItem(widget.item.productID, widget.item.barCode),
        );
      }
    }

    // Refresh basket to update the counter
    context.read<BasketBloc>().add(const FetchBasketItems());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BasketBloc, BaseState<BasketItemModel>>(
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
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Dismissible(
          key: ValueKey(widget.item.productID),
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
          child: Container(
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.codGray : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Stack(
              children: [
                if (_hasDiscount)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomLeft: Radius.circular(8.r),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${"the_last_price_was".tr()} ${((widget.item.discountPercent * widget.item.price) - widget.item.price).toStringAsFixed(2)} ${"EGP".tr()}',
                          style: AppTextTheme.caption.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlexibleImage(
                          source: widget.item.productImage,
                          width: context.screenWidth * 0.2,
                          height: context.screenHeight * 0.1,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.productName,
                              style: AppTextTheme.caption,
                            ),
                            SizedBox(height: 5.h),
                            _buildPriceSection(),
                            Row(
                              children: [
                                const Spacer(),
                                IntrinsicWidth(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 36.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widget.item.salesQuantity > 0
                                          ? 4.w
                                          : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.white,
                                          AppColors.backgroundColor.withValues(
                                            alpha: 0.3,
                                          ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18.r),
                                      border: Border.all(
                                        color: AppColors.mainAppColor
                                            .withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.mainAppColor
                                              .withValues(alpha: 0.15),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Spacer(),
                                        Container(
                                          width: 24.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.mainAppColor,
                                                AppColors.tealAccentColor,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.mainAppColor
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                              BorderRadius.circular(14.r),
                                              onTap: _isProcessing
                                                  ? null
                                                  : () => _incrementQuantity(
                                                widget.item.barCode,
                                              ),
                                              child: Center(
                                                child: _isProcessing
                                                    ? SizedBox(
                                                  width: 12.w,
                                                  height: 12.h,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color
                                                    >(
                                                      AppColors.white,
                                                    ),
                                                  ),
                                                )
                                                    : Icon(
                                                  Icons.add,
                                                  color: AppColors.white,
                                                  size: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${widget.item.salesQuantity}',
                                          style: AppTextTheme.titleSmallBold,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 24.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.mainAppColor,
                                                AppColors.tealAccentColor,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.mainAppColor
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                              BorderRadius.circular(14.r),
                                              onTap: _isProcessing
                                                  ? null
                                                  : () => _decrementQuantity(
                                                widget.item.barCode,
                                              ),
                                              child: Center(
                                                child: _isProcessing
                                                    ? SizedBox(
                                                  width: 12.w,
                                                  height: 12.h,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color
                                                    >(
                                                      AppColors.white,
                                                    ),
                                                  ),
                                                )
                                                    : Icon(
                                                  Icons.remove,
                                                  color: AppColors.white,
                                                  size: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    final hasDiscount =
        widget.item.priceAfterDiscount > 0 &&
            widget.item.priceAfterDiscount < widget.item.price;
    final limit = widget.item.customerQuantity;
    final salesQty = widget.item.salesQuantity;

    if (hasDiscount && limit > 0 && salesQty > limit) {
      final discountQty = limit.toInt();
      final normalQty = salesQty - discountQty;
      final discountTotal = discountQty * widget.item.priceAfterDiscount;
      final normalTotal = normalQty * widget.item.price;
      final total = discountTotal + normalTotal;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${'discount_price'.tr()}: ',
                style: AppTextTheme.bodySmall.copyWith(fontSize: 10.sp),
              ),
              Text(
                '$discountQty x ${widget.item.priceAfterDiscount.toStringAsFixed(2)} ${'EGP'.tr()}',
                style: AppTextTheme.bodySmall.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${'normal_price'.tr()}: ',
                style: AppTextTheme.bodySmall.copyWith(fontSize: 10.sp),
              ),
              Text(
                '$normalQty x ${widget.item.price.toStringAsFixed(2)} ${'EGP'.tr()}',
                style: AppTextTheme.bodySmall.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
          Row(
            children: [
              Text('${'total'.tr()}: ', style: AppTextTheme.caption),
              SizedBox(width: 8.w),
              Text(
                '${total.toStringAsFixed(2)} ${'EGP'.tr()}',
                style: AppTextTheme.bodySmall,
              ),
            ],
          ),
        ],
      );
    }

    final price = hasDiscount
        ? widget.item.priceAfterDiscount
        : widget.item.price;
    final total = price * salesQty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${'price'.tr()}: ', style: AppTextTheme.bodySmall),
            SizedBox(width: 8.w),
            Text(
              '${price.toStringAsFixed(2)} ${'EGP'.tr()}',
              style: AppTextTheme.bodySmall,
            ),
          ],
        ),
        Row(
          children: [
            Text('${'total'.tr()}: ', style: AppTextTheme.caption),
            SizedBox(width: 8.w),
            Text(
              '${total.toStringAsFixed(2)} ${'EGP'.tr()}',
              style: AppTextTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
