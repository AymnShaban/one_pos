part of '../../basket_imports.dart';

class PlaceDetailsWidget extends StatelessWidget {
  const PlaceDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final address = getIt<IUserCache>().getUserModel() ?? CustomerModel(
      customerId: 0, password: '', email: '', regionId: 0, placeId: 0, addressId: '',
   );
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.isDarkMode
                ? AppColors.white.withValues(alpha: 0.2)
                : AppColors.black,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: (context.isDarkMode ? Colors.white : Colors.black)
                  .withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(8.r),
          color: context.isDarkMode ? AppColors.codGray : Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.location_pin, color: AppColors.mainAppColor, size: 30),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'delivery_to:'.tr()}${address.districtName}',
                  style: AppTextTheme.body2Bold,
                ),
                SizedBox(height: 3.h),
                Text(
                  '${address.districtName}, ${address.regionName}, ${address.addressNotes}',
                  style: AppTextTheme.body2Bold,
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AddNewAddressScreen(),
                //   ),
                // );
              },
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.mainAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
