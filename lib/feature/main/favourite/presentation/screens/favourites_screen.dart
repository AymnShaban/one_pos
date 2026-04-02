import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../../core/widgets/pull_to_refresh.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../manager/add_to_favorite_bloc/add_to_favorite_bloc.dart';
import '../../manager/add_to_favorite_bloc/add_to_favorite_event.dart';
import '../../models/favorite_model.dart';
import '../widget/favourite_item.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel != null && context.mounted) {
      context.read<FavoriteBloc>().add(
        GetFavorite(customerModel.customerPhone!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(titleText: "favorites".tr()),
      body: PullToRefresh(
        onRefresh: () async {
          final customerModel = getIt<IUserCache>().getUserModel();
          if (customerModel != null && context.mounted) {
            context.read<FavoriteBloc>().add(
              GetFavorite(customerModel.customerPhone!),
            );
          }
        },
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                BlocListener<FavoriteBloc, BaseState<FavoriteModel>>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.items.length != current.items.length ||
                      previous.items.any(
                        (prev) => !current.items.any(
                          (curr) => curr.productID == prev.productID,
                        ),
                      ),
                  listener: (context, state) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (state.status == Status.success &&
                        state.metadata.containsKey('productId')) {
                      debugPrint(
                        'Success SnackBar: productID=${state.metadata['productId']}',
                      );
                      showCustomSnackBar(
                        context,
                        "Favorite updated successfully",
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        if (context.mounted) {
                          debugPrint('Resetting state');
                          context.read<FavoriteBloc>().add(
                            ResetFavoriteState(),
                          );
                        }
                      });
                    } else if (state.status == Status.failure &&
                        state.metadata.containsKey('productId')) {
                      FailureWidget(
                        state: state,
                        onRetry: () {
                          final customerModel = getIt<IUserCache>()
                              .getUserModel();
                          if (customerModel != null && context.mounted) {
                            debugPrint(
                              'Retrying GetFavorite: customerPhone=${customerModel.customerPhone}',
                            );
                            context.read<FavoriteBloc>().add(
                              GetFavorite(customerModel.customerPhone!),
                            );
                          }
                        },
                        errorMessage: 'Failed to load favorites',
                      );
                    }
                  },
                  child: BlocBuilder<FavoriteBloc, BaseState<FavoriteModel>>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status ||
                        previous.items.length != current.items.length ||
                        previous.items.any(
                          (prev) => !current.items.any(
                            (curr) => curr.productID == prev.productID,
                          ),
                        ),
                    builder: (context, state) {
                      if (state.status == Status.loading &&
                          state.items.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == Status.failure) {
                        return FailureWidget(
                          state: state,
                          onRetry: () {
                            final customerModel = getIt<IUserCache>()
                                .getUserModel();
                            if (customerModel != null && context.mounted) {
                              context.read<FavoriteBloc>().add(
                                GetFavorite(customerModel.customerPhone!),
                              );
                            }
                          },
                          errorMessage: 'Failed to load favorites',
                        );
                      } else {
                        final favorites = state.items;
                        debugPrint('Rendering ${favorites.length} items');
                        return Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: favorites.isEmpty
                              ? Center(
                                  child: Text(
                                    'No favorites found'.tr(),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.codGray,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: favorites.length,
                                  itemBuilder: (context, index) =>
                                      FavouriteItem(favorite: favorites[index]),
                                ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 500.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
