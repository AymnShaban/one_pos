import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/flexible_image.dart';
import '../../models/products_details_model.dart';

class ImagesSection extends StatelessWidget {
  final ProductDetailsModel product;
  final int customerId;

  const ImagesSection({
    super.key,
    required this.product,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 1),
            // Reduced duration for smoother feel
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: FlexibleImage(
              source: product.productImage ?? '',
              width: MediaQuery.sizeOf(context).width * 0.6,
              fit: BoxFit.scaleDown,
              height: 250.h,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            "${context.locale.languageCode == 'ar' ? product.productArName : (product.productEnName)} \n  ${product.barCode} S:N",
            style: AppTextTheme.heading2.copyWith(
              color: context.isDarkMode ? Colors.white : AppColors.black,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          product.description1 ??
              product.description2 ??
              product.description3 ??
              product.description4 ??
              product.description5 ??
              "no_description_available".tr(),
          style: AppTextTheme.captionBold.copyWith(
            color: context.isDarkMode ? Colors.white70 : AppColors.hitColor,
          ),
        ),
      ],
    );
  }
}
