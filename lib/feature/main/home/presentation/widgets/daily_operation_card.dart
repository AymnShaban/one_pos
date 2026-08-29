import 'package:easy_localization/easy_localization.dart';
import 'package:one_pos/feature/main/home/models/daily_operation_model.dart';

import '../../../../../core/helper/helper.dart';
import '../../manager/today_bills_bloc/daily_operation_bloc.dart';

class DailyOperationList extends StatelessWidget {
  const DailyOperationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w,right: 16.w, top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'daily_operations'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

            ],
          ),



          // List
          BlocBuilder<DailyOperationsBloc, BaseState<List<DailyOperationModel>>>(
            builder: (context, state) {
              switch (state.status) {
                case Status.loading:
                  return _buildLoadingState();

                case Status.success:
                  if (state.data == null || state.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return _buildBillsList(state.data!);

                case Status.failure:
                  return const SizedBox.shrink();

                case Status.initial:
                  return const SizedBox.shrink();

                case Status.isLoadingMore:

                  throw UnimplementedError();
                case Status.custom:

                  throw UnimplementedError();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.line),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.mainAppColor,
          ),
        ),
      ),
    );
  }


  Widget _buildBillsList(List<DailyOperationModel> bills) {

    final displayBills = bills.length > 5 ? bills.sublist(0, 5) : bills;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      
      itemCount: displayBills.length,
      padding: EdgeInsets.symmetric( vertical: 8.h),
      separatorBuilder: (_, __) {

        return SizedBox(height: 2.h);
      },
      itemBuilder: (context, index) {
        return DailyOperationCard(bill: displayBills[index]);
      },
    );
  }
}

class DailyOperationCard extends StatelessWidget {
  final DailyOperationModel bill;

  const DailyOperationCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.mainAppColor.withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainAppColor.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [

          Container(
            width: 38.w,
            height: 38.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainAppColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${bill.blNo}',
              style: TextStyle(
                color: AppColors.mainAppColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),

          SizedBox(width: 12.w),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.locale.languageCode == 'ar'
                            ? bill.patternName
                            : bill.patternEnName,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12.w, color: AppColors.grey),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        _formatDate(bill.blDate),
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.greenBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              bill.finalValue,
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }
}
