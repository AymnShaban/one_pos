import 'package:easy_localization/easy_localization.dart';


import '../../../../../core/extension/context_extension.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/services/service_locator/services_imports.dart';
import '../../../basket/basket_imports.dart';
import '../../manager/product_details_bloc/product_details_bloc.dart';
import '../../manager/product_details_bloc/product_details_event.dart';
import '../../models/products_details_model.dart';
import '../sections/details_section.dart';
import '../sections/images_section.dart';

class DetailsScreen extends StatefulWidget {
  final int productId;
  final int initialQuantity;
  final double stockQuantity;

  const DetailsScreen({
    super.key,
    required this.stockQuantity,
    required this.productId,
    required this.initialQuantity,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsBloc>().add(
      FetchProductDetails(
        productId: widget.productId,
        customerPhone: getIt<IUserCache>()
            .getUserModel()!
            .customerPhone
            .toString(),
        customerId: getIt<IUserCache>().getUserModel()!.customerId,
      ),
    );
  }

  void _refetchProductDetails() {
    context.read<ProductDetailsBloc>().add(
      FetchProductDetails(
        productId: widget.productId,
        customerPhone: getIt<IUserCache>()
            .getUserModel()!
            .customerPhone
            .toString(),
        customerId: getIt<IUserCache>().getUserModel()!.customerId,
      ),
    );
  }


  Widget _handleDescriptions(ProductDetailsModel product) {
    List<String> descriptions = [];
    final lang = context.locale.languageCode;

    if (lang == 'ar') {
      if (product.description1?.isNotEmpty ?? false) descriptions.add(product.description1!);
      if (product.description2?.isNotEmpty ?? false) descriptions.add(product.description2!);
    } else if (lang == 'en') {
      if (product.description3?.isNotEmpty ?? false) descriptions.add(product.description3!);
      if (product.description4?.isNotEmpty ?? false) descriptions.add(product.description4!);
    } else if (lang == 'fr') {
      if (product.description5?.isNotEmpty ?? false) descriptions.add(product.description5!);
      if (product.description6?.isNotEmpty ?? false) descriptions.add(product.description6!);
    }

    if (descriptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: descriptions.map((desc) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              desc,
              style: AppTextTheme.caption.copyWith(
                color: context.isDarkMode ? Colors.white70 : AppColors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddToBasketBloc, BaseState<void>>(
          listener: (context, state) {
            if (state.status == Status.success &&
                state.metadata['productId'] == widget.productId) {
              _refetchProductDetails();
            }
          },
        ),
        BlocListener<BasketBloc, BaseState<BasketItemModel>>(
          listener: (context, state) {
            if (state.status == Status.success &&
                state.metadata['productId'] == widget.productId) {
              _refetchProductDetails();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.isDarkMode ? AppColors.black : AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.isDarkMode ? AppColors.black : AppColors.backgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: context.isDarkMode ? Colors.white : AppColors.mainAppColor,
            ),
          ),
        ),
        body: BlocBuilder<ProductDetailsBloc, BaseState<ProductDetailsModel>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == Status.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Failed to load product details',
                  style: AppTextTheme.heading1.copyWith(color: AppColors.red),
                ),
              );
            } else {
              final displayProduct = state.data ?? ProductDetailsModel.empty();
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImagesSection(
                      product: displayProduct,
                      customerId: getIt<IUserCache>()
                          .getUserModel()!
                          .customerId,
                    ),
                    DetailsSection(
                      product: displayProduct,
                      customerId: getIt<IUserCache>()
                          .getUserModel()!
                          .customerId,
                      initialQuantity: widget.initialQuantity,
                      stockQuantity: widget.stockQuantity,
                    ),
                    // handle the 10 descriptions
                    _handleDescriptions(displayProduct),

                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
