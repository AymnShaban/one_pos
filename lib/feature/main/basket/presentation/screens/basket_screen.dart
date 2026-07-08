part of '../../basket_imports.dart';

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

  /// Extracts `(invoiceID, invoiceNo)` from the create-invoice response,
  /// which arrives as a JSON string like
  /// `{"message":"...","invoiceID":15,"invoiceNo":793}`. Returns null if the
  /// payload can't be parsed or the ids are missing.
  (int, int)? _parseCreatedInvoice(String? successData) {
    if (successData == null || successData.isEmpty) return null;
    try {
      final decoded = jsonDecode(successData);
      if (decoded is! Map) return null;
      final id = (decoded['invoiceID'] ?? decoded['InvoiceID']) as num?;
      final no = (decoded['invoiceNo'] ?? decoded['InvoiceNo']) as num?;
      if (id == null || no == null) return null;
      return (id.toInt(), no.toInt());
    } catch (_) {
      return null;
    }
  }

  void _checkAuthentication() {
    final customerModel = getIt<IUserCache>().getUserModel();

    if (customerModel != null) {
      context.read<BasketBloc>().add(const FetchBasketItems());
    } else {
      if (mounted) {
        showCustomSnackBar(context, 'please_log_in_to_manage_cart'.tr());
        Navigator.pushReplacement(context, LoginScreen.route());
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

                SizedBox(height: 12.h),

                // const PlaceDetailsWidget(),

                ProductListWrapper(
                  child: BlocBuilder<BasketBloc, BaseState<ItemModel>>(
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
                        return Column(
                          children: [
                            const BasketTableHeader(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                loggerInfo(
                                    "basket items : ${items[index].barCode}");

                                return ProductBasketItem(
                                  item: items[index],
                                  bloc: context.read<BasketBloc>(),
                                );
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                // Conditionally show OrderMinimumWidget only when total < 2000
                const BasketPosSummary(),
                SizedBox(height: 10.h),
                BlocListener<NewInvoiceBloc, NewInvoiceState>(
                  listenWhen: (prev, curr) =>
                      prev.submitStatus != curr.submitStatus,
                  listener: (context, state) {
                    if (state.submitStatus == Status.success) {
                      showCustomSnackBar(
                        context,
                        'invoice_created_successfully'.tr(),
                      );
                      // Empty the basket after a successful sale — the shared
                      // BasketBloc singleton is also what SalesTab renders, so
                      // clearing it leaves SalesTab showing an empty basket.
                      context.read<BasketBloc>().add(const ClearBasket());
                      // Pull the created invoice ids out of the create
                      // response ({message, invoiceID, invoiceNo}).
                      final ids = _parseCreatedInvoice(state.successData);
                      // Pop back to the SalesTab shell (first route), then open
                      // the read-only details screen for the new invoice.
                      Navigator.popUntil(context, (r) => r.isFirst);
                      if (ids != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InvoiceDetailsScreen(
                              invoiceId: ids.$1,
                              invoiceNo: ids.$2,
                            ),
                          ),
                        );
                      }
                    } else if (state.submitStatus == Status.failure) {
                      showCustomSnackBar(
                        context,
                        state.errorMessage ?? 'error'.tr(),
                      );
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }
}