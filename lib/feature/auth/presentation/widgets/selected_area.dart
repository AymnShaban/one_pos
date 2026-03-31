import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/helper/helper.dart';

import '../../bloc/areas_bloc/areas_bloc.dart';
import '../../models/areas_model.dart';

class AddressStepWidget extends StatefulWidget {
  final TextEditingController controller;

  const AddressStepWidget({super.key, required this.controller});

  @override
  State<AddressStepWidget> createState() => _AddressStepWidgetState();
}

class _AddressStepWidgetState extends State<AddressStepWidget> {
  AreasModel? selectedArea;

  @override
  void initState() {
    super.initState();
    // Load previously selected area if exists
    selectedArea = HiveServiceImpl.instance.getDeliveryAddition();
    if (selectedArea != null) {
      widget.controller.text = selectedArea!.districtName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Area Dropdown
        BlocBuilder<AreasBloc, BaseState<AreasModel>>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainAppColor,
                ),
              );
            }

            if (state.isFailure) {
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  state.errorMessage ?? 'error_loading_areas'.tr(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final areas = state.items;

            if (areas.isEmpty) {
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('no_areas_available'.tr()),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<AreasModel>(
                value: selectedArea,
                decoration: InputDecoration(
                  hintText: 'select_area'.tr(),
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.mainAppColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                isExpanded: true,
                items: areas.map((area) {
                  return DropdownMenuItem<AreasModel>(
                    value: area,
                    child: Text(
                      area.districtName,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                }).toList(),
                onChanged: (AreasModel? newArea) async {
                  if (newArea != null) {
                    setState(() {
                      selectedArea = newArea;
                      widget.controller.text = newArea.districtName;
                    });

                    // Save to Hive
                    await HiveServiceImpl.instance.cacheDeliveryAddition(newArea);

                    logger('Selected area: ${newArea.districtName}');
                    logger('Delivery value: ${newArea.deliveryValue}');
                  }
                },
              ),
            );
          },
        ),

        SizedBox(height: 16.h),

        // Display selected area details
        if (selectedArea != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'delivery_details'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainAppColor,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildDetailRow(
                  'delivery_fee'.tr(),
                  '${selectedArea!.deliveryValue} ${'currency'.tr()}',
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.mainAppColor,
            ),
          ),
        ],
      ),
    );
  }
}