import 'package:flutter/material.dart';

import '../../data/models/branch_model.dart';

import 'checkbox_row.dart';

class BranchesSection extends StatelessWidget {
  const BranchesSection({
    super.key,
    required this.branches,
    required this.onToggleBranch,
    required this.onToggleAll,
  });

  final List<BranchModel> branches;
  final ValueChanged<BranchModel> onToggleBranch;
  final ValueChanged<bool> onToggleAll;

  bool get _allSelected =>
      branches.isNotEmpty && branches.every((b) => b.isSelected);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxRow(
          label: 'الكل',
          value: _allSelected,
          onChanged: onToggleAll,
          isHighlighted: true,
        ),
        for (int i = 0; i < branches.length; i++)
          CheckboxRow(
            label: branches[i].name,
            value: branches[i].isSelected,
            onChanged: (_) => onToggleBranch(branches[i]),
            showBottomBorder: i != branches.length - 1,
          ),
      ],
    );
  }
}
