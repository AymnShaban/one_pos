import 'package:easy_localization/easy_localization.dart';

import '../../revenue_analysis_import.dart';

class AccountSection extends StatelessWidget {
  final int? selectedAccountId;
  final VoidCallback onTap;

  const AccountSection({
    super.key,
    required this.selectedAccountId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RevenueAccountsBloc, RevenueAccountsState, RevenueAccountModel?>(
      selector: (state) => state.selectedAccount,
      builder: (context, selectedAccount) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterSectionLabel(title: "account".tr()),
            FilterFieldTile(
              value: selectedAccount?.name ?? "",
              placeholder: "select_account".tr(),
              onTap: onTap,
            ),

          ],
        );
      },
    );
  }
}