import 'package:easy_localization/easy_localization.dart';

import '../../revenue_analysis_import.dart';
class RevenueAccountPickerDialog extends StatefulWidget {
  const RevenueAccountPickerDialog({super.key});

  @override
  State<RevenueAccountPickerDialog> createState() =>
      _RevenueAccountPickerDialogState();
}

class _RevenueAccountPickerDialogState
    extends State<RevenueAccountPickerDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RevenueAccountsBloc>();

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'select_account'.tr(),
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400.h,
        child: Column(
          children: [
            _buildSearchField(bloc),
            Expanded(child: _buildAccountList(bloc)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr(), style: TextStyle(fontSize: 14.sp, color: AppColors.textMuted)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          ),
          child: Text('confirm'.tr(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }

  Widget _buildSearchField(RevenueAccountsBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'search'.tr(),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20.sp),
            hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textMuted),
          ),
          onChanged: (value) {
            bloc.add(LoadRevenueAccounts(search: value.isNotEmpty ? value : null));
          },
        ),
      ),
    );
  }

  Widget _buildAccountList(RevenueAccountsBloc bloc) {
    return BlocBuilder<RevenueAccountsBloc, RevenueAccountsState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.accounts.isEmpty) {
          return Center(
            child: Text(
              'no_accounts_found'.tr(),
              style: TextStyle(fontSize: 14.sp, color: AppColors.textMuted),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemCount: state.accounts.length,
          separatorBuilder: (_, __) => Divider(height: 1.h, color: const Color(0xFFEEF1F7)),
          itemBuilder: (context, index) {
            final item = state.accounts[index];
            final isSelected = state.selectedAccountId == item.id;
            return Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                leading: Radio<int>(
                  value: item.id,
                  groupValue: state.selectedAccountId,
                  onChanged: (_) => _selectAccount(context, bloc, item),
                  activeColor: AppColors.brand,
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppColors.brand : AppColors.textDark,
                  ),
                ),
                subtitle: Text(item.code, style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted)),
                onTap: () => _selectAccount(context, bloc, item),
              ),
            );
          },
        );
      },
    );
  }

  void _selectAccount(BuildContext context, RevenueAccountsBloc bloc, RevenueAccountModel account) {
    bloc.add(SelectRevenueAccount(accountId: account.id));
    Navigator.of(context).pop(account);
  }
}