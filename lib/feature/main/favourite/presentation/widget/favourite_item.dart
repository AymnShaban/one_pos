import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../../../feature/main/favourite/manager/add_to_favorite_bloc/add_to_favorite_bloc.dart';

import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../core/widgets/flexible_image.dart';
import '../../manager/add_to_favorite_bloc/add_to_favorite_event.dart';
import '../../models/add_to_favorite_request.dart';
import '../../models/favorite_model.dart';

class FavouriteItem extends StatefulWidget {
  final FavoriteModel favorite;

  const FavouriteItem({super.key, required this.favorite});

  @override
  State<FavouriteItem> createState() => _FavouriteItemState();
}

class _FavouriteItemState extends State<FavouriteItem> {
  int quantity = 0;
  bool showCounter = false;

  void _removeFromFavorites() {
    final customerModel = getIt<IUserCache>().getUserModel();
    if (customerModel == null) {
      if (mounted) {
        showCustomSnackBar(
          context,
          'Please log in to manage favorites',
        );
      }
      return;
    }

    if (context.mounted) {
      context.read<FavoriteBloc>().add(
        DeleteFavorite(
          AddAndDeleteFavoriteRequest(
            productID: widget.favorite.productID!,
            customerPhone: customerModel.customerPhone!,
            barCode: widget.favorite.barCode ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final locale = context.locale;

    final String title = locale.languageCode == 'ar'
        ? widget.favorite.productName ?? ''
        : widget.favorite.productEnName ?? widget.favorite.productName ?? '';
    final String priceStr =
        '${(widget.favorite.finalPrice).toStringAsFixed(2)} ${'EGP'.tr()}';

    return BlocBuilder<FavoriteBloc, BaseState<FavoriteModel>>(
      buildWhen: (previous, current) =>
          current.metadata['productId'] == widget.favorite.productID &&
          (current.status == Status.loading ||
              current.status == Status.failure),
      builder: (context, state) {
        final isLoading =
            state.status == Status.loading &&
            state.metadata['productId'] == widget.favorite.productID;

        return Card(
          color: AppColors.white1,
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FlexibleImage(
                    source: widget.favorite.productImage!,
                    width: screenWidth * 0.22,
                    height: screenHeight * 0.12,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextTheme.captionBold,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        priceStr,
                        style: AppTextTheme.titleLarge,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Align(
                        alignment: locale == const Locale('ar')
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _removeFromFavorites,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.005,
                            ),
                          ),
                          child: Text(
                            'delete_from_favorite'.tr(),
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: AppColors.white1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
