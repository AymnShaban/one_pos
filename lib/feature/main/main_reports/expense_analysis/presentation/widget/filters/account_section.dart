import 'package:easy_localization/easy_localization.dart';
import '../../../expense_analysis_imports.dart';
import '../mixins/expense_analysis_helper.dart';

class AccountSection extends StatelessWidget with ExpenseAnalysisHelper {
  final int? selectedAccountId;
  final Function(int) onAccountSelected;
  final VoidCallback onShowPicker;

  const AccountSection({
    super.key,
    required this.selectedAccountId,
    required this.onAccountSelected,
    required this.onShowPicker,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseAccountsBloc, ExpenseAccountsState>(
      buildWhen: (previous, current) {
        return previous.accounts != current.accounts ||
            previous.selectedAccountId != current.selectedAccountId ||
            previous.status != current.status;
      },
      builder: (context, state) {

        if (state.status == Status.success &&
            state.accounts.isNotEmpty &&
            selectedAccountId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final firstAccount = state.accounts.first;
            if (selectedAccountId == null) {
              context
                  .read<ExpenseAccountsBloc>()
                  .add(SelectExpenseAccount(accountId: firstAccount.id));
              onAccountSelected(firstAccount.id);
            }
          });
        }

        String displayValue = '';
        if (state.status == Status.success && state.selectedAccount != null) {
          displayValue = state.selectedAccount!.name;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionHeader("account".tr()),
            FilterFieldTile(
              value: displayValue,
              placeholder: "select_account".tr(),
              onTap: onShowPicker,
            ),

          ],
        );
      },
    );
  }
}