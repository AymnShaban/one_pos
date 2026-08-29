import 'package:easy_localization/easy_localization.dart';
import '../../branch_profit_import.dart';

class BranchSelectionSection extends StatefulWidget {
  const BranchSelectionSection({super.key});

  @override
  State<BranchSelectionSection> createState() => _BranchSelectionSectionState();
}

class _BranchSelectionSectionState extends State<BranchSelectionSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingState();
        }
        if (state.status == Status.failure) {
          return _buildErrorState(
            message: state.errorMessage ?? 'error_loading_branches'.tr(),
            onRetry: () => context.read<BranchesBloc>().add(LoadBranches()),
          );
        }
        return _buildBranchesList(context, state);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.blue,
            ),
          ),
          SizedBox(width: 14.w),
          Text(
            'loading_branches'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState({required String message, required VoidCallback onRetry}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(borderColor: AppColors.red),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: AppColors.red,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            ),
            child: Text(
              'retry'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesList(BuildContext context, BranchesState state) {
    final branches = state.branches;
    final selectedIds = state.selectedBranchIds;
    final isRTL = context.locale.languageCode == 'ar';
    final allSelected = branches.isNotEmpty &&
        branches.every((branch) => selectedIds.contains(branch.id));

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
                  'branches'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),





              if (branches.isNotEmpty)
                InkWell(
                  onTap: () {
                    final newSelection = allSelected
                        ? <int>{}
                        : branches.map((b) => b.id).toSet();
                    context.read<BranchesBloc>().add(
                      UpdateBranchesSelection(branchIds: newSelection),
                    );
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

              // زر الفتح/الإغلاق
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
                ...branches.map((branch) {
                  final isSelected = selectedIds.contains(branch.id);
                  final displayName = isRTL
                      ? (branch.braName ?? branch.braEName ?? '')
                      : (branch.braEName ?? branch.braName ?? '');

                  return _buildBranchCheckbox(
                    displayName: displayName,
                    isSelected: isSelected,
                    onChanged: (value) {
                      final newSelection = Set<int>.from(selectedIds);
                      if (value == true) {
                        newSelection.add(branch.id);
                      } else {
                        newSelection.remove(branch.id);
                      }
                      context.read<BranchesBloc>().add(
                        UpdateBranchesSelection(branchIds: newSelection),
                      );
                    },
                  );
                }),
              ],
            )

        ],
      ),
    );
  }

  Widget _buildBranchCheckbox({
    required String displayName,
    required bool isSelected,
    required Function(bool?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),

      child: CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(
          displayName,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.blue : AppColors.textDark,
          ),
        ),
        value: isSelected,
        onChanged: onChanged,
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

  BoxDecoration _cardDecoration({Color? borderColor}) {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: borderColor ?? AppColors.line.withOpacity(0.3),
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