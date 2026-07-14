import 'package:flutter/material.dart';

import 'toggle_switch_row.dart';

/// Content of the "خيارات العرض" card.
class DisplayOptionsSection extends StatelessWidget {
  const DisplayOptionsSection({
    super.key,
    required this.showReturns,
    required this.onShowReturnsChanged,
    required this.hideCustomerOffer,
    required this.onHideCustomerOfferChanged,
    required this.customerBranch,
    required this.onCustomerBranchChanged,
  });

  final bool showReturns;
  final ValueChanged<bool> onShowReturnsChanged;
  final bool hideCustomerOffer;
  final ValueChanged<bool> onHideCustomerOfferChanged;
  final bool customerBranch;
  final ValueChanged<bool> onCustomerBranchChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleSwitchRow(
          label: 'إظهار المرتجعات',
          value: showReturns,
          onChanged: onShowReturnsChanged,
        ),
        ToggleSwitchRow(
          label: 'بدون عرض العميل',
          value: hideCustomerOffer,
          onChanged: onHideCustomerOfferChanged,
        ),
        ToggleSwitchRow(
          label: 'فرع العميل',
          value: customerBranch,
          onChanged: onCustomerBranchChanged,
          showBottomBorder: false,
        ),
      ],
    );
  }
}
