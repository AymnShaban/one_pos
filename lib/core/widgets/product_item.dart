import 'package:easy_localization/easy_localization.dart';
import '../../core/helper/helper.dart';
import '../../feature/auth/presentation/screens/login_screen.dart';
import '../../feature/main/basket/basket_imports.dart';
import '../../feature/main/invoice_setup/invoice_setup_imports.dart';
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
  late bool _isInCart;
  late int _quantity;
  bool _isProcessing = false;

  /// The currently chosen sellable unit. Drives the displayed price and the
  /// values baked into the basket line on dispatch. `null` when the product
  /// has no `product_UnitsandPrices` rows — in that case we fall back to
  /// `widget.product`'s legacy price/unit/barcode fields.
  ProductUnit? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _isInCart = widget.initialIsInCart;
    _quantity = widget.initialQuantity;
    _isProcessing = false;
    _selectedUnit = widget.product.units.isNotEmpty
        ? widget.product.units.first
        : null;
  }

  @override
  void didUpdateWidget(covariant EnhancedProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuantity != widget.initialQuantity ||
        oldWidget.initialIsInCart != widget.initialIsInCart) {
      setState(() {
        _quantity = widget.initialQuantity;
        _isInCart = widget.initialIsInCart;
      });
    }
    // Product swapped under us — re-seed the unit selection.
    if (oldWidget.product.productId != widget.product.productId) {
      _selectedUnit = widget.product.units.isNotEmpty
          ? widget.product.units.first
          : null;
    }
  }

  // ── Price selection (driven by `_selectedUnit`) ─────────────────────────

  double get _displayPrice {
    final u = _selectedUnit;
    if (u != null) {
      return u.retail > 0
          ? u.retail
          : (u.sale > 0 ? u.sale : widget.product.price);
    }
    return widget.product.price;
  }

  double get _displayPriceAfterDiscount {
    final u = _selectedUnit;
    if (u != null) {
      return u.effectivePrice > 0
          ? u.effectivePrice
          : widget.product.priceAfterDiscount;
    }
    return widget.product.priceAfterDiscount;
  }

  /// Same model the basket persists — sale (priceAfterDiscount) `<` list
  /// (price) is a discount; sale `>` list is a "second unit" price; equal or
  /// zero priceAfterDiscount means no offer.
  bool get _hasDiscount =>
      _displayPriceAfterDiscount > 0 &&
      _displayPriceAfterDiscount != _displayPrice;

  bool get _canAddToCart {
    if (widget.product.isOutOfStock) return false;
    return _quantity < widget.product.stockQuantity;
  }

  /// The exact ItemModel to send to the basket — overlays the selected
  /// unit's price/unit/barcode onto the base product so the cart line and
  /// any downstream order request carry the right values.
  ItemModel get _basketItem {
    final u = _selectedUnit;
    if (u == null) return widget.product;
    final bc = (u.barcode != null && u.barcode!.isNotEmpty)
        ? u.barcode!
        : widget.product.barCode;
    return widget.product.copyWith(
      price: _displayPrice,
      priceAfterDiscount: _displayPriceAfterDiscount,
      unitArName: u.unitArName,
      unitEnName: u.unitEnName,
      unitValue: u.unitValue,
      barCode: bc,
    );
  }

  void _onUnitChanged(ProductUnit? u) {
    if (u == null || u == _selectedUnit) return;
    setState(() => _selectedUnit = u);
  }

  // ── Basket dispatches ───────────────────────────────────────────────────

  Future<void> _addToCart() async {
    final customerModel = getIt<IUserCache>().getUserModel();

    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_add_to_cart'.tr());
        Navigator.pushReplacement(context, LoginScreen.route());
      }
      return;
    }

    final stock = widget.product.stockQuantity.toInt();
    if (stock > 0 && _quantity >= stock) {
      if (mounted) showCustomSnackBar(context, 'max_quantity_reached'.tr());
      return;
    }

    setState(() {
      _isInCart = true;
      _quantity++;
    });

    _dispatchToBasket(customerId: customerModel.id, quantity: _quantity);
  }

  Future<void> _incrementQuantity() async {
    final customerModel = getIt<IUserCache>().getUserModel();

    final stockQuantity = widget.product.stockQuantity;

    if (stockQuantity > 0 && _quantity >= stockQuantity) {
      if (mounted) {
        showCustomSnackBar(context, 'max_quantity_reached'.tr());
      }
      return;
    }

    if (_quantity >= 1) {
      await _showQuantityDialog(isFromDecrement: false);
    } else {
      setState(() {
        _quantity++;
      });

      if (context.mounted) {
        _dispatchToBasket(
          customerId: customerModel?.id ?? 0,
          quantity: _quantity,
        );
      }
    }
  }

  Future<void> _decrementQuantity() async {
    final customerModel = getIt<IUserCache>().getUserModel();

    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_manage_cart'.tr());
        Navigator.pushReplacement(context, LoginScreen.route());
      }
      return;
    }

    if (_quantity > 1) {
      await _showQuantityDialog(isFromDecrement: true);
    } else {
      setState(() {
        _quantity--;
        context.read<BasketBloc>().add(
          DeleteBasketItem(
            widget.product.productId,
            widget.product.productCode,
          ),
        );
        context.read<BasketBloc>().add(const FetchBasketItems());
      });
    }
  }

  void _dispatchToBasket({required int customerId, required int quantity}) {
    final item = _basketItem;
    context.read<AddToBasketBloc>().add(
          AddToBasket(
            AddToBasketRequest(
              customerID: customerId,
              productID: item.productId,
              productBarcode: item.barCode,
              item: item,
              quantity: quantity,
            ),
          ),
        );
    context.read<BasketBloc>().add(const FetchBasketItems());
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

    // Currency label for every amount the card renders. Prefer the explicit
    // `currencySymbol`; fall back to the locale-appropriate currency name
    // so empty-symbol payloads still show something readable. Reactively
    // tracks `InvoiceSetupBloc.selectedCurrency` so flipping the currency
    // dropdown updates the cards live.
    final selectedCurrency =
        context.watch<InvoiceSetupBloc>().state.selectedCurrency;
    final currencyLabel = (selectedCurrency?.currencySymbol.isNotEmpty == true)
        ? selectedCurrency!.currencySymbol
        : (isArabic
            ? (selectedCurrency?.currencyArName ?? '')
            : (selectedCurrency?.currencyEnName ?? ''));

    return Container(
      width: itemWidth,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Container with light grey background
          Container(
            height: 130.h,
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

                const SizedBox(height: 4),
                _buildUnitSelector(isArabic),

                const SizedBox(height: 6),

                // Price Section — driven by the selected unit.
                ProductPriceSection(
                  price: _displayPrice,
                  priceAfterDiscount: _displayPriceAfterDiscount,
                  hasDiscount: _hasDiscount,
                  customerQuantity: widget.product.customerQuantity,
                  currencyLabel: currencyLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Unit row ────────────────────────────────────────────────────────────

  /// Compact unit picker. With 0–1 units, renders the static label the
  /// catalogue had before. With 2+ units, renders a tappable inline
  /// dropdown so the cashier can switch unit → price right on the card.
  Widget _buildUnitSelector(bool isArabic) {
    final units = widget.product.units;

    String unitLabel(ProductUnit u) {
      final name = isArabic ? u.unitArName : u.unitEnName;
      return '${_fmtUnitValue(u.unitValue)} $name'.trim();
    }

    if (units.length <= 1) {
      // Legacy behavior — keep the same one-line caption.
      final name = isArabic
          ? (widget.product.unitArName ??
              widget.product.defaultUnitArName ??
              '')
          : (widget.product.unitEnName ??
              widget.product.defaultUnitEnName ??
              '');
      final unitString =
          '${widget.product.unitValue ?? ""} $name'.trim();
      if (unitString.isEmpty) return const SizedBox.shrink();
      return Text(
        unitString,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    final selected = _selectedUnit ?? units.first;
    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProductUnit>(
          value: selected,
          isDense: true,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down,
              size: 16.sp, color: Colors.grey.shade700),
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
          items: [
            for (final u in units)
              DropdownMenuItem<ProductUnit>(
                value: u,
                child: Text(
                  unitLabel(u),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: _onUnitChanged,
        ),
      ),
    );
  }

  /// Whole numbers plain ("1"), fractions trimmed ("0.5", not "0.50").
  String _fmtUnitValue(num v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    var s = v.toStringAsFixed(2);
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    return s;
  }

  // ── Add / counter button ────────────────────────────────────────────────

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

    if (result == null) return;

    final entered = int.tryParse(result);
    if (entered == null || entered < 0) return;

    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_add_to_cart'.tr());
        Navigator.pushReplacement(context, LoginScreen.route());
      }
      return;
    }

    final stock = widget.product.stockQuantity.toInt();
    var target = entered;
    if (stock > 0 && target > stock) {
      target = stock;
      if (mounted) showCustomSnackBar(context, 'max_quantity_reached'.tr());
    }

    if (target == _quantity) return;
    if (!mounted) return;

    setState(() {
      _quantity = target;
      _isInCart = target > 0;
    });

    _dispatchToBasket(customerId: customerModel.id, quantity: target);
  }
}
