import 'package:easy_localization/easy_localization.dart';
import '../../branch_profit_import.dart';

class BranchProfitOptions {
  final bool byAccount;
  final bool showExpenses;
  final bool analysis;
  final bool postedOnly;
  final bool profitFromLastPrice;
  final bool orderByBranch;
  final bool groupByBranch;

  const BranchProfitOptions({
    this.byAccount = true,
    this.showExpenses = true,
    this.analysis = true,
    this.postedOnly = true,
    this.profitFromLastPrice = true,
    this.orderByBranch = true,
    this.groupByBranch = true,
  });

  BranchProfitOptions copyWith({
    bool? byAccount,
    bool? showExpenses,
    bool? analysis,
    bool? postedOnly,
    bool? profitFromLastPrice,
    bool? orderByBranch,
    bool? groupByBranch,
  }) {
    return BranchProfitOptions(
      byAccount: byAccount ?? this.byAccount,
      showExpenses: showExpenses ?? this.showExpenses,
      analysis: analysis ?? this.analysis,
      postedOnly: postedOnly ?? this.postedOnly,
      profitFromLastPrice: profitFromLastPrice ?? this.profitFromLastPrice,
      orderByBranch: orderByBranch ?? this.orderByBranch,
      groupByBranch: groupByBranch ?? this.groupByBranch,
    );
  }

  List<OptionData> getOptions() {
    return [
     // OptionData(key: 'byAccount', label: 'by_account', icon: Icons.account_balance, value: byAccount),
      OptionData(key: 'showExpenses', label: 'show_expenses', icon: Icons.money_off, value: showExpenses),
      OptionData(key: 'analysis', label: 'analysis', icon: Icons.analytics, value: analysis),
      OptionData(key: 'postedOnly', label: 'posted_only', icon: Icons.verified, value: postedOnly),
      OptionData(key: 'profitFromLastPrice', label: 'profit_from_last_price', icon: Icons.trending_up, value: profitFromLastPrice),
      //OptionData(key: 'orderByBranch', label: 'order_by_branch', icon: Icons.sort, value: orderByBranch),
      OptionData(key: 'groupByBranch', label: 'group_by_branch', icon: Icons.group_work, value: groupByBranch),
    ];
  }

  bool get allSelected => getOptions().every((opt) => opt.value == true);

  BranchProfitOptions toggleAll(bool selectAll) {
    return BranchProfitOptions(
      byAccount: selectAll,
      showExpenses: selectAll,
      analysis: selectAll,
      postedOnly: selectAll,
      profitFromLastPrice: selectAll,
      orderByBranch: selectAll,
      groupByBranch: selectAll,
    );
  }

  BranchProfitOptions updateOption(String key, bool value) {
    switch (key) {

      case 'showExpenses':
        return copyWith(showExpenses: value);
      case 'analysis':
        return copyWith(analysis: value);
      case 'postedOnly':
        return copyWith(postedOnly: value);
      case 'profitFromLastPrice':
        return copyWith(profitFromLastPrice: value);

      case 'groupByBranch':
        return copyWith(groupByBranch: value);
      default:
        return this;
    }
  }
}

class OptionData {
  final String key;
  final String label;
  final IconData icon;
  final bool value;

  const OptionData({
    required this.key,
    required this.label,
    required this.icon,
    required this.value,
  });
}

class OptionsSection extends StatefulWidget {
  final BranchProfitOptions options;
  final ValueChanged<BranchProfitOptions> onChanged;

  const OptionsSection({
    super.key,
    required this.options,
    required this.onChanged,
  });

  @override
  State<OptionsSection> createState() => _OptionsSectionState();
}

class _OptionsSectionState extends State<OptionsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final optionsList = widget.options.getOptions();
    final allSelected = widget.options.allSelected;
    final selectedCount = optionsList.where((opt) => opt.value == true).length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Expanded(
                child: Text(
                  'options'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  final newOptions = widget.options.toggleAll(!allSelected);
                  widget.onChanged(newOptions);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: allSelected
                        ? AppColors.blue.withOpacity(0.1)
                        : AppColors.line.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: allSelected
                          ? AppColors.blue.withOpacity(0.3)
                          : AppColors.line.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        allSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: allSelected ? AppColors.blue : AppColors.textMuted,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                         'select_all'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: allSelected ? AppColors.blue : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.line.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          if (_isExpanded)
            Column(
              children: [
                ...optionsList.map((option) {
                  return _buildOptionCheckbox(
                    option: option,
                    onChanged: (value) {
                      final newOptions = widget.options.updateOption(option.key, value);
                      widget.onChanged(newOptions);
                    },
                  );
                }),
              ],
            )

        ],
      ),
    );
  }

  Widget _buildOptionCheckbox({
    required OptionData option,
    required ValueChanged<bool> onChanged,
  }) {
    final isSelected = option.value;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(8.r),

      ),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Row(
          children: [


            Text(
              option.label.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.blue : AppColors.textDark,
              ),
            ),
          ],
        ),
        value: isSelected,
        onChanged: (bool? value) => onChanged(value ?? false), // ✅ إصلاح الخطأ هنا
        activeColor: AppColors.blue,
        checkColor: AppColors.white,
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        tileColor: Colors.transparent,
        selected: isSelected,
        selectedTileColor: Colors.transparent,
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.blue.withOpacity(0.1);
            }
            return null;
          },
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: AppColors.line.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12.r,
          offset: Offset(0, 4.h),
        ),
      ],
    );
  }
}