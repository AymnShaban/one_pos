import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../core/widgets/pull_to_refresh.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/product_list_wrapper.dart';
import '../../../../auth/presentation/screens/view/login_screen.dart';
import '../../manager/basket_bloc/basket_bloc.dart';
import '../../manager/basket_bloc/basket_event.dart';
import '../../models/basket_model.dart';
import '../widgets/order_minimum_widget.dart';
import '../widgets/payment_button_section.dart';
import '../widgets/place_details_widget.dart';
import '../widgets/product_basket_item.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  void _checkAuthentication() {
    final customerModel = getIt<IUserCache>().getUserModel();

    if (customerModel != null) {
      context.read<BasketBloc>().add(const FetchBasketItems());
    } else {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_manage_cart'.tr());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.isDarkMode ? Colors.white : AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: context.isDarkMode ? AppColors.black : AppColors.mainAppColor,
        title: Text(
          'basket_details'.tr(),
          style: AppTextTheme.titleLarge.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: context.isDarkMode ? AppColors.black : AppColors.white,
      body: PullToRefresh(
        topPadding: context.screenHeight * 0.06,
        onRefresh: () async {
          context.read<BasketBloc>().add(const FetchBasketItems());
        },
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
                  builder: (context, state) {
                    final total = state.items.fold<double>(
                        0, (sum, item) => sum + item.totalSplitPrice
                    );

                    // Show widget only if total is below minimum (2000)
                    if (total < 200 && state.items.isNotEmpty) {
                      return const OrderMinimumWidget();
                    }
                    return const SizedBox.shrink(); // Hide when total >= 2000
                  },
                ),

                SizedBox(height: 12.h),

                const PlaceDetailsWidget(),

                ProductListWrapper(
                  child: BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
                    buildWhen: (previous, current) =>
                    current.status != previous.status ||
                        current.items != previous.items,
                    builder: (context, state) {
                      if (state.status == Status.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        // Filter out items with 0 quantity
                        final items = state.items;
                        if (items.isEmpty) {
                          return Center(
                            child: Text(
                              'cart_is_empty'.tr(),
                              style: AppTextTheme.bodyMedium,
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            loggerInfo("basket items : ${items[index].barCode}");

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProductBasketItem(
                                item: items[index],
                                bloc: context.read<BasketBloc>(),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                // Conditionally show OrderMinimumWidget only when total < 2000
                SizedBox(height: 10.h),

                SizedBox(height: 10.h),
                const PaymentButtonSection(),
                SizedBox(height: 500.h),
              ],
            ),
          );
        },
      ),
    );
  }
}