import 'package:easy_localization/easy_localization.dart';
import '../../core/helper/helper.dart';
import '../../feature/auth/presentation/screens/login_screen.dart';
import '../../feature/main/basket/basket_imports.dart';
import '../../feature/main/details/manager/product_details_bloc/product_details_bloc.dart';
import '../../feature/main/details/presentation/screens/details_screen.dart';
import '../../feature/main/favourite/favorite_imports.dart';
import '../models/item_model.dart';
import '../services/service_locator/services_imports.dart';
import 'custom_snack_bar.dart';
import 'flexible_image.dart';
import 'product_item/widgets/product_price_section.dart';

class EnhancedProductItem extends StatefulWidget {
  const EnhancedProductItem({
    super.key,
    required this.product,
    this.initialIsFavorite = false,
    this.initialIsInCart = false,
    this.initialQuantity = 1,
  });

  final ItemModel product;
  final bool initialIsFavorite;
  final bool initialIsInCart;
  final int initialQuantity;

  @override
  State<EnhancedProductItem> createState() => _EnhancedProductItemState();
}

class _EnhancedProductItemState extends State<EnhancedProductItem> {
  late bool _isFavorite;
  late bool _isInCart;
  late int _quantity;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
    _isInCart = widget.initialIsInCart;
    _quantity = widget.initialQuantity;
    _isProcessing = false;
  }

  void _toggleFavorite() {
    final previousFavoriteState = _isFavorite;
    setState(() {
      _isFavorite = !_isFavorite;
    });

    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_manage_favorites'.tr());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
      setState(() {
        _isFavorite = previousFavoriteState;
      });
      return;
    }

    if (_isFavorite) {
      context.read<FavoriteBloc>().add(
        AddFavorite(
          AddAndDeleteFavoriteRequest(
            productID: widget.product.productId,
            customerPhone: customerModel.customerPhone!,
            barCode: widget.product.productCode,
          ),
        ),
      );
    } else {
      context.read<FavoriteBloc>().add(
        DeleteFavorite(
          AddAndDeleteFavoriteRequest(
            productID: widget.product.productId,
            customerPhone: customerModel.customerPhone!,
            barCode: widget.product.productCode,
          ),
        ),
      );
    }
  }

  Future<void> _addToCart() async {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_add_to_cart'.tr());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
      return;
    }

    setState(() {
      _isInCart = true;
      _quantity++;
    });

    final request = AddToBasketRequest(
      customerID: customerModel.customerId,
      productID: widget.product.productId,
      productBarcode: widget.product.productCode,
    );
    context.read<AddToBasketBloc>().add(AddToBasket(request));
  }

  Future<void> _incrementQuantity() async {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) return;

    final stockQuantity = widget.product.stockQuantity;

    if (stockQuantity > 0 && _quantity >= stockQuantity) {
      if (mounted) {
        showCustomSnackBar(context, 'max_quantity_reached'.tr());
      }
      return;
    }

    if (_quantity >= 10) {
      await _showQuantityDialog(isFromDecrement: false);
    } else {
      setState(() {
        _quantity++;
      });

      if (context.mounted) {
        context.read<AddToBasketBloc>().add(
          AddToBasket(
            AddToBasketRequest(
              customerID: customerModel.customerId,
              productID: widget.product.productId,
              productBarcode: widget.product.productCode,
            ),
          ),
        );
      }
    }
  }

  Future<void> _decrementQuantity() async {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_manage_cart'.tr());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()),
        );
      }
      return;
    }

    if (_quantity > 15) {
      await _showQuantityDialog(isFromDecrement: true);
    } else {
      setState(() {
        _quantity--;
        // context.read<BasketBloc>().add(
        //   DeleteBasketItem(
        //     widget.product.productId,
        //     widget.product.productCode,
        //   ),
        // );
      });
    }
  }

  bool get _hasDiscount =>
      widget.product.price != widget.product.priceAfterDiscount;

  bool get _canAddToCart {
    if (widget.product.isOutOfStock) return false;
    return _quantity < widget.product.stockQuantity;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "stockQuantity: ${widget.product.stockQuantity.toString()} of item ${widget.product.productArName}",
    );
    final itemWidth = 160.w;
    final isArabic = context.locale.languageCode == 'ar';
    final productName = isArabic
        ? widget.product.productArName
        : widget.product.productEnName;

    final unitString =
        '${widget.product.unitValue ?? ""} ${isArabic ? (widget.product.unitArName ?? widget.product.defaultUnitArName ?? "") : (widget.product.unitEnName ?? widget.product.defaultUnitEnName ?? "")}'
            .trim();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<ProductDetailsBloc>(),
              child: DetailsScreen(
                productId: widget.product.productId,
                initialQuantity: widget.initialQuantity,
                stockQuantity: widget.product.stockQuantity.toDouble(),
              ),
            ),
          ),
        );
      },
      child: Container(
        width: itemWidth,
        decoration: BoxDecoration(
          color: Colors
              .transparent, // Replaced shadow/white background with a transparent container
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Container with light grey background
            Container(
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  // Centered Product Image
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: FlexibleImage(
                        source: widget.product.productImage ?? '',
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.contain,
                        isProduct: true,
                      ),
                    ),
                  ),

                  // Top Right: Favorite Button
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: _buildFavoriteButton(),
                  ),

                  // Out of Stock Overlay
                  if (widget.product.isOutOfStock) _buildOutOfStockBanner(),

                  // Bottom Right: Add/Counter Button
                  if (!widget.product.isOutOfStock || _quantity > 0)
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: _buildAdvancedCounterBox(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Below Image Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Special Offer / Best Seller Badge
                  if (_hasDiscount)
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'special_offer'
                              .tr(), // Or 'best_seller'.tr() if you prefer that text
                          style: TextStyle(
                            color: const Color(0xFFD97706),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Product Name
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),

                  if (unitString.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    // Subtitle / Weight
                    Text(
                      unitString,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Price Section
                  ProductPriceSection(
                    price: widget.product.price,
                    priceAfterDiscount: widget.product.priceAfterDiscount,
                    hasDiscount: _hasDiscount,
                    customerQuantity: widget.product.customerQuantity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedCounterBox() {
    if (_quantity == 0 && _canAddToCart) {
      return InkWell(
        onTap: () {
          if (_isProcessing) return;
          _isProcessing = true;
          _addToCart().whenComplete(() {
            if (mounted) _isProcessing = false;
          });
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Center(
            child: Icon(Icons.add, color: const Color(0xFFD94A38), size: 20.sp),
          ),
        ),
      );
    }

    return IntrinsicWidth(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 36.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () {
                if (_isProcessing) return;
                _isProcessing = true;
                _decrementQuantity().whenComplete(() {
                  if (mounted) _isProcessing = false;
                });
              },
              child: Container(
                width: 28.w,
                height: 28.h,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.remove, color: Colors.black87, size: 18.sp),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 32.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                '$_quantity',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (_canAddToCart)
              InkWell(
                borderRadius: BorderRadius.circular(14.r),
                onTap: () {
                  if (_isProcessing) return;
                  _isProcessing = true;
                  _incrementQuantity().whenComplete(() {
                    if (mounted) _isProcessing = false;
                  });
                },
                child: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: const Color(0xFFD94A38),
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return AnimatedScale(
      scale: _isFavorite ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: InkWell(
        onTap: _toggleFavorite,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.black87,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildOutOfStockBanner() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'unavailable'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showQuantityDialog({required bool isFromDecrement}) async {
    final title = isFromDecrement
        ? 'Quantity is high. Enter the desired total quantity'.tr()
        : 'Quantity is getting high. Enter the desired total quantity:'.tr();

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
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

        final diff = newTotal - _quantity;

        // Handle both increasing and decreasing
        if (diff != 0) {
          final isIncreasing = diff > 0;
          final iterations = diff.abs();

          for (int i = 0; i < iterations; i++) {
            if (isIncreasing) {
              // Adding to basket
              final stockQuantity = widget.product.stockQuantity;
              if (stockQuantity > 0 && _quantity >= stockQuantity) {
                if (mounted) {
                  showCustomSnackBar(context, 'max_quantity_reached'.tr());
                }
                break;
              }

              if (mounted) {
                // context.read<AddToBasketBloc>().add(
                //   AddToBasket(
                //     AddToBasketRequest(
                //       customerID: customerModel.customerId,
                //       productID: widget.product.productId,
                //       productBarcode: widget.product.productCode,
                //     ),
                //   ),
                // );
              }
              _quantity++;
              _isInCart = true;
            } else {
              // Removing from basket
              if (mounted) {
                // context.read<BasketBloc>().add(
                //   DeleteBasketItem(
                //     widget.product.productId,
                //     widget.product.productCode,
                //   ),
                // );
              }
              _quantity--;
            }
          }
          setState(() {});
        }
      }
    }
  }
}
