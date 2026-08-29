import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';

class DisplayOptionsSectionWidget extends StatelessWidget {
  final bool showReturns;
  final bool hideClient;
  final bool clientBranch;
  final Function(bool) onShowReturnsChanged;
  final Function(bool) onHideClientChanged;
  final Function(bool) onClientBranchChanged;
  final bool isLoading;



  const DisplayOptionsSectionWidget({
    required this.showReturns,
    required this.hideClient,
    required this.clientBranch,
    required this.onShowReturnsChanged,
    required this.onHideClientChanged,
    required this.onClientBranchChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(title: "display_options".tr()),
        SizedBox(height: 8.h),
        ToggleCard(options: [
          ToggleOption(
            title: "show_returns".tr(),
            value: showReturns,
            onChanged: (v) {
              if (isLoading) return;
              onShowReturnsChanged(v);
            },
          ),
          ToggleOption(
            title: "without_customer".tr(),
            value: hideClient,
            onChanged: (v) {
              if (isLoading) return;
              onHideClientChanged(v);
            },
          ),
          ToggleOption(
            title: "customer_branch".tr(),
            value: clientBranch,
            onChanged: (v) {
              if (isLoading) return;
              onClientBranchChanged(v);
            },
          ),
        ]),
      ],
    );
  }
}

