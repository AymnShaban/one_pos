part of '../../basket_imports.dart';

/// Dialog that searches customer accounts as the user types (500ms debounce,
/// no search button). Returns the selected customer map via Navigator.pop.
class CustomerSearchDialog extends StatelessWidget {
  const CustomerSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountSearchBloc>(),
      child: const _CustomerSearchView(),
    );
  }
}

class _CustomerSearchView extends StatefulWidget {
  const _CustomerSearchView();

  @override
  State<_CustomerSearchView> createState() => _CustomerSearchViewState();
}

class _CustomerSearchViewState extends State<_CustomerSearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<AccountSearchBloc>().add(SearchAccounts(value));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        decoration: BoxDecoration(
          color:  AppColors.white,
          borderRadius: BorderRadius.circular(12.r),

        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'new_invoice.search_account'.tr(),
                style: AppTextTheme.titleSmallBold,
              ),
              SizedBox(height: 12.h),
              Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.mainAppColor),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: AppTextTheme.captionBold,
                  decoration: InputDecoration(
                    hintText: 'new_invoice.search_account'.tr(),
                    border: InputBorder.none,
                    hintStyle: AppTextTheme.caption,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onChanged,
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 320.h,
                width: double.maxFinite,
                child:
                    BlocBuilder<AccountSearchBloc, BaseState<CustomerAccountModel>>(
                  builder: (context, state) {
                    final isAr = context.locale.languageCode == 'ar';
                    if (state.status == Status.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == Status.failure) {
                      return Center(
                        child: Text(
                          state.errorMessage ?? 'common.error'.tr(),
                          style: AppTextTheme.caption
                              .copyWith(color: AppColors.red),
                        ),
                      );
                    }
                    if (state.items.isEmpty) {
                      return Center(
                        child: Text(
                          'no_products'.tr(),
                          style: AppTextTheme.caption,
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, i) {
                        final customer = state.items[i];
                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            title: Text(
                              customer.displayName(isAr),
                              style: AppTextTheme.captionBold,
                            ),
                            subtitle: Text(
                              customer.phone??"",
                              style: AppTextTheme.caption,
                            ),
                            onTap: () => Navigator.pop(context, customer),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
