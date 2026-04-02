// order_minimum_widget.dart
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/helper/helper.dart';
import '../../manager/basket_bloc/basket_bloc.dart';
import '../../models/basket_model.dart';

class OrderMinimumWidget extends StatelessWidget {
  const OrderMinimumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 233.w,
        height: 125.h,
        padding: const EdgeInsets.only(right: 8, left: 8),
        decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.codGray : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.isDarkMode
                ? AppColors.white.withValues(alpha: 0.2)
                : AppColors.mainAppColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 5, top: 10, left: 5),
          child: BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
            builder: (context, state) {
              final total = state.items.fold<double>(0, (sum, item) => sum + ((item.priceAfterDiscount > 0 ? item.priceAfterDiscount : item.price) * item.salesQuantity));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoRow(
                    label: "the_minimum_order".tr(),
                    value: "200 ${"EGP".tr()}".tr(),
                  ),
                  Row(
                    children: [
                      Text(
                        "total".tr(),
                        style: AppTextTheme.captionBold,
                      ),
                      const Spacer(),
                      Text(
                        "${total.toStringAsFixed(2)} ${"EGP".tr()}",
                        style: AppTextTheme.labelMedium11Bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                 if(total <= 200)  Text.rich(
                   TextSpan(
                     text: "purchase_remaining_intro"
                         .tr(),
                     children: [
                       TextSpan(
                         text: "${200 - total}",
                         style: AppTextTheme.labelSmall9.copyWith(fontWeight: FontWeight.bold), // optional styling
                       ),
                       TextSpan(
                         text: "EGP".tr(),
                       ),
                     ],
                   ),
                   style: AppTextTheme.labelSmall9,
                 ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

