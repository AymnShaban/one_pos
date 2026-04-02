import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/helper/helper.dart';
import '../../manager/basket_bloc/basket_bloc.dart';
import '../../models/basket_model.dart';

class PaymentButtonSection extends StatelessWidget {
  const PaymentButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
          builder: (context, state) {
            final total = state.items.fold<double>(
              0,
                  (sum, item) => sum + item.totalSplitPrice,
            );
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppTextTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : AppColors.black,
                      ),
                      TextSpan(
                        children: [
                          TextSpan(text: total.toStringAsFixed(2)),
                          TextSpan(text: 'EGP'.tr()),
                        ],
                      ),
                    ),
                    Text(
                      'subtotal'.tr(),
                      style: AppTextTheme.captionBold.copyWith(
                        color: context.isDarkMode ? Colors.white70 : AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 138,
                  height: 45,
                  child:
                     ( getIt<IUserCache>().getUserModel()?.districtName?.isEmpty ?? true)
                      ? ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const AddNewAddressScreen(),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: total >= 200
                                ? AppColors.mainAppColor
                                : AppColors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'payment'.tr(),
                              style: AppTextTheme.labelMedium11Bold.copyWith(
                                color: AppColors.white1,
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: total >= 200
                              ? () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => MultiBlocProvider(
                                  //       providers: [
                                  //         BlocProvider(
                                  //           create: (context) =>
                                  //               getIt<OrderBloc>(),
                                  //         ),
                                  //         BlocProvider.value(
                                  //           value: getIt<BasketBloc>(),
                                  //         ),
                                  //       ],
                                  //       child: DeliveryTimeScreen(
                                  //         totalAmount: total,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );

                                }
                              : null,
                        // dont forget to change the total amount validation to total >= 2000
                          style: ElevatedButton.styleFrom(
                            backgroundColor: total >= 20
                                ? AppColors.mainAppColor
                                : AppColors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'payment'.tr(),
                              style: AppTextTheme.titleLarge.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
