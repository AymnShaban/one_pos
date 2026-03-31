import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/constant/app_colors.dart' show AppColors;
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_colors.dart';

class CustomPlaceWidget extends StatelessWidget {
  const CustomPlaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.5),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.category,colorFilter: ColorFilter.mode(AppColors.secondaryColor, BlendMode.srcIn),),
            SizedBox(width: 5.w),
            Text(
              'address'.tr(),
              style: TextStyle(
                fontFamily: "Alexandria",
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
