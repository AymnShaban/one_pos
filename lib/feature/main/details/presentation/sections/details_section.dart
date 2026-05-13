import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/services/service_locator/services_imports.dart';
import '../../../basket/basket_imports.dart';
import '../../models/products_details_model.dart';

class DetailsSection extends StatelessWidget {
  final ProductDetailsModel product;
  final int customerId;
  final int initialQuantity;
  final double stockQuantity;

  const DetailsSection({
    super.key,
    required this.product,
    required this.customerId,
    this.initialQuantity = 1,
    required this.stockQuantity,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("defaultUnitArName: ${product.productImages.first.productArName}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'choose_units'.tr(),
              style: AppTextTheme.titleLargeBold.copyWith(
                color: context.isDarkMode ? Colors.white : AppColors.black,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: product.productImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.productImages[index].barcode} S:N',
                          style: AppTextTheme.captionBold.copyWith(
                            color: context.isDarkMode ? Colors.white70 : AppColors.hitColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildUnitPrice(context, product.productImages[index]),
                        SizedBox(height: 2.h),
                        Text(
                          '${"quantity".tr()} ${product.productImages[index].stockQty} ${product.productImages[index].unitArName}',
                          style: AppTextTheme.captionBold.copyWith(
                            color: context.isDarkMode ? Colors.white70 : AppColors.hitColor,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    _DetailsCounterBox(
                      product: product,
                      customerId: customerId,
                      initialQuantity: initialQuantity,
                      stockQuantity: stockQuantity,
                      barcode: product.productImages[index].barcode,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 1,
                  color: context.isDarkMode ? Colors.white10 : AppColors.secondaryColor,
                  width: double.infinity,
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}

class _DetailsCounterBox extends StatefulWidget {
  final ProductDetailsModel product;
  final int customerId;
  final int initialQuantity; // Initial quantity in basket
  final double stockQuantity;
  final String barcode;

  const _DetailsCounterBox({
    required this.product,
    required this.customerId,
    this.initialQuantity = 0,
    required this.stockQuantity,
    required this.barcode,
  });

  @override
  State<_DetailsCounterBox> createState() => _DetailsCounterBoxState();
}

class _DetailsCounterBoxState extends State<_DetailsCounterBox> {
  bool _isProcessing = false;

  void _decrementQuantity(int currentQuantity) {
    if (currentQuantity > 0 && !_isProcessing) {
      setState(() => _isProcessing = true);
      // Call DeleteBasketItem to reduce quantity by 1 or remove if it's the last item
      context.read<BasketBloc>().add(
        DeleteBasketItem(widget.product.productId, widget.barcode),
      );
      // Refresh basket to update the counter
      context.read<BasketBloc>().add(const FetchBasketItems());
    }
  }

  void _incrementQuantity(int currentQuantity) {
    // Check if stock is available
    if (widget.stockQuantity <= 0 || _isProcessing) {
      return;
    }

    // Check if we've reached stock limit
    if (currentQuantity >= widget.stockQuantity) {
      return;
    }

    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      return;
    }

    setState(() => _isProcessing = true);
    final request = AddToBasketRequest(
      customerID: customerModel.employeeId??1,
      productID: widget.product.productId,
      productBarcode: widget.barcode,
    );
    context.read<AddToBasketBloc>().add(AddToBasket(request));

    // Refresh basket to update the counter
    context.read<BasketBloc>().add(const FetchBasketItems());
  }

  void _addToCart() {
    // Only add if stock is available
    if (widget.stockQuantity > 0 && !_isProcessing) {
      final customerModel = getIt<IUserCache>().getUserModel();
      if (customerModel == null) {
        return;
      }

      setState(() => _isProcessing = true);
      final request = AddToBasketRequest(
        customerID: customerModel.employeeId??1,
        productID: widget.product.productId,
        productBarcode: widget.barcode,
      );
      context.read<AddToBasketBloc>().add(AddToBasket(request));

      // Refresh basket to update the counter
      context.read<BasketBloc>().add(const FetchBasketItems());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BasketBloc, BaseState<BasketItemModel>>(
          listener: (context, state) {
            if (state.status == Status.success || state.status == Status.failure) {
              if (mounted) setState(() => _isProcessing = false);
            }
          },
        ),
        BlocListener<AddToBasketBloc, BaseState<void>>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              if (mounted) setState(() => _isProcessing = false);
            }
            // Success will eventually trigger BasketBloc success which will also reset _isProcessing
          },
        ),
      ],
      child: BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
        builder: (context, basketState) {
          // Find the item in basket by barcode
          final basketItems = basketState.items.where(
                (item) => item.barCode == widget.barcode.toString(),
          );

          final quantity = basketItems.isNotEmpty ? basketItems.first.salesQuantity : 0;

          final isOutOfStock = widget.stockQuantity <= 0;
          final isInBasket = quantity > 0;
          final canShowIncrementButton = widget.stockQuantity > 0 && quantity < widget.stockQuantity;

          // CONDITION 1: Item NOT in basket (quantity == 0)
          if (!isInBasket) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Show "Out of Stock" badge if no stock available
                if (isOutOfStock)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Text(
                      'out_of_stock'.tr(),
                      style: AppTextTheme.captionBold.copyWith(
                        color: context.isDarkMode ? Colors.white38 : AppColors.grey,
                      ),
                    ),
                  )
                // Show "Add to Cart" button if stock is available
                else
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.mainAppColor, AppColors.tealAccentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainAppColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18.r),
                        onTap: _isProcessing ? null : _addToCart,
                        child: Center(
                          child: _isProcessing
                              ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                            ),
                          )
                              : Icon(Icons.add, color: AppColors.white, size: 20.sp),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }

          // CONDITION 2: Item IS in basket (quantity > 0)
          // Show quantity counter with increment/decrement buttons
          return IntrinsicWidth(
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.isDarkMode ? AppColors.codGray : AppColors.white,
                    context.isDarkMode ? AppColors.black.withValues(alpha: 0.3) : AppColors.backgroundColor.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: context.isDarkMode ? Colors.white24 : AppColors.mainAppColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainAppColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decrement Button (always visible when item is in basket)
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? AppColors.codGray : AppColors.mainAppColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.isDarkMode ? Colors.white38 : AppColors.mainAppColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: _isProcessing ? null : () => _decrementQuantity(quantity),
                        child: Center(
                          child: _isProcessing
                              ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainAppColor),
                            ),
                          )
                              : Icon(
                            Icons.remove,
                            color: context.isDarkMode ? Colors.white : AppColors.mainAppColor,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Quantity Display
                  Container(
                    constraints: BoxConstraints(minWidth: 40.w),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: context.isDarkMode ? Colors.white : AppColors.mainAppColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Increment Button - Only show if stockQuantity > 0 AND quantity < stock
                  if (canShowIncrementButton)
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.mainAppColor, AppColors.tealAccentColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainAppColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.r),
                          onTap: _isProcessing ? null : () => _incrementQuantity(quantity),
                          child: Center(
                            child: _isProcessing
                                ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                              ),
                            )
                                : Icon(Icons.add, color: AppColors.white, size: 18.sp),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );

}}

Widget _buildUnitPrice(BuildContext context, ProductUnitModel unit) {
  final hasDiscount = unit.priceAfterDiscount > 0 && unit.priceAfterDiscount < unit.price;
  final limit = unit.customerQuantity;

  if (hasDiscount && limit > 0) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${unit.priceAfterDiscount} ${"EGP".tr()} (${'limit'.tr()} ${limit.toInt()})',
          style: AppTextTheme.captionBold.copyWith(
            color: AppColors.mainAppColor,
          ),
        ),
        Text(
          '${'after_limit_price'.tr()}: ${unit.price} ${"EGP".tr()}',
          style: AppTextTheme.labelSmall9Bold.copyWith(
            color: context.isDarkMode ? Colors.white38 : AppColors.grey,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  return Text(
    '${unit.priceAfterDiscount > 0 ? unit.priceAfterDiscount : unit.price} ${"EGP".tr()} ${'for_unit'.tr()}',
    style: AppTextTheme.captionBold.copyWith(
      color: context.isDarkMode ? Colors.white70 : AppColors.hitColor,
    ),
  );
}

