import 'package:easy_localization/easy_localization.dart';



import '../../../expense_analysis_imports.dart';

class AccountPickerDialog extends StatefulWidget {
  final ExpenseAccountsBloc bloc;
  final int? selectedAccountId;
  final Function(int) onAccountSelected;

  const AccountPickerDialog({
    super.key,
    required this.bloc,
    required this.selectedAccountId,
    required this.onAccountSelected,
  });

  @override
  State<AccountPickerDialog> createState() => _AccountPickerDialogState();
}

class _AccountPickerDialogState extends State<AccountPickerDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'select_account'.tr(),
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400.h,
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.mainAppColor),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: AppTextTheme.captionBold,
                  decoration: InputDecoration(
                    hintText: 'new_invoice.search_account'.tr(),
                    border: InputBorder.none,
                    hintStyle: AppTextTheme.caption,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    widget.bloc.add(
                      LoadExpenseAccounts(
                        search: value.isNotEmpty ? value : null,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Accounts List
            Expanded(
              child: BlocBuilder<ExpenseAccountsBloc, ExpenseAccountsState>(
                bloc: widget.bloc,
                buildWhen: (previous, current) {
                  return previous.accounts != current.accounts ||
                      previous.selectedAccountId != current.selectedAccountId ||
                      previous.status != current.status;
                },
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.accounts.isEmpty) {
                    return Center(
                      child: Text(
                        'no_accounts_found'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: state.accounts.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.h,
                      color: const Color(0xFFEEF1F7),
                    ),
                    itemBuilder: (context, index) {
                      final item = state.accounts[index];
                      final isSelected = state.selectedAccountId == item.id;

                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.brand
                                  : AppColors.textDark,
                            ),
                          ),
                          onTap: () {
                            widget.bloc.add(
                              SelectExpenseAccount(accountId: item.id),
                            );
                            widget.onAccountSelected(item.id);
                            Navigator.of(context).pop();
                          },
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
      actions: [
        TextButton(
          onPressed: () {
            _searchController.clear();
            Navigator.of(context).pop();
          },
          child: Text(
            'cancel'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }
}