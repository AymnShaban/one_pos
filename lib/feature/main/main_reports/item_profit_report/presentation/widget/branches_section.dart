import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';


class BranchesSectionWidget extends StatelessWidget {
  final bool isLoading;
  final bool multiSelect;

  const BranchesSectionWidget({
    super.key,
    required this.isLoading,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<BranchesBloc, BranchesState>(
          buildWhen: (previous, current) {
            return previous.selectedBranchIds != current.selectedBranchIds ||
                previous.branches.length != current.branches.length;
          },
          builder: (context, state) {
            final total = state.branches.length;
            final selected = state.selectedBranchIds.length;

            String countText;
            if (state.isAllSelected) {
              countText = "$selected / $total";
            } else if (selected == 0) {
              countText = "$selected / $total";
            } else {
              countText = "$selected / $total";
            }

            return FilterSectionLabel(
              title: "branches".tr(),
              count: countText,
            );
          },
        ),
        SizedBox(height: 8.h),
        BlocBuilder<BranchesBloc, BranchesState>(
          buildWhen: (previous, current) {
            return previous.status != current.status ||
                previous.selectedBranchIds != current.selectedBranchIds ||
                previous.branches.length != current.branches.length;
          },
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(strokeWidth: 2.w),
              );
            }

            if (state.status == Status.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'error'.tr(),
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              );
            }

            final branches = state.branches;
            final isAllSelected = state.isAllSelected;

            return Opacity(
              opacity: isLoading ? 0.5 : 1.0,
              child: IgnorePointer(
                ignoring: isLoading,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    children: [
                      // ✅ "All" option
                      SwitchListTile.adaptive(
                        dense: true,
                        value: isAllSelected,
                        activeColor: AppColors.brand,
                        onChanged: isLoading
                            ? null
                            : (_) {
                          if (isAllSelected) {

                            _updateSelection(context, const []);
                          } else {

                            _updateSelection(
                              context,
                              state.branches.map((b) => b.id).toList(),
                            );
                          }
                        },
                        title: Text(
                          "all_branches".tr(),
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: isAllSelected ? AppColors.brand : AppColors.textDark,
                          ),
                        ),
                      ),
                      if (branches.isNotEmpty)
                        Divider(
                          height: 1.h,
                          thickness: 1,
                          color: AppColors.line,
                          indent: 16.w,
                          endIndent: 16.w,
                        ),
                      // ✅ Individual branches
                      ...branches.map((branch) {
                        final isSelected = state.isBranchSelected(branch.id);

                        return SwitchListTile.adaptive(
                          dense: true,
                          value: isSelected,
                          activeColor: AppColors.brand,
                          onChanged: isLoading
                              ? null
                              : (_) {
                            if (multiSelect) {
                              // ✅ Multi-select mode
                              final currentIds = List<int>.from(state.selectedBranchIds);

                              if (isSelected) {
                                currentIds.remove(branch.id);
                              } else {
                                currentIds.add(branch.id);
                              }

                              _updateSelection(context, currentIds);
                            } else {
                              // ✅ Single select mode
                              if (isSelected) {
                                // If selected, select all
                                _updateSelection(
                                  context,
                                  state.branches.map((b) => b.id).toList(),
                                );
                              } else {
                                // Select this branch only
                                _updateSelection(context, [branch.id]);
                              }
                            }
                          },
                          title: Text(
                            branch.braName,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.brand : AppColors.textDark,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ✅ Update method using the new Event
  void _updateSelection(BuildContext context, List<int> branchIds) {
    context.read<BranchesBloc>().add(
      UpdateBranchesSelection.fromList(branchIds),
    );
  }
}