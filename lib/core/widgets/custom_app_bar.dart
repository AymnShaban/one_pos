import '../../core/theme/app_text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constant/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  final String? icon;

  const CustomAppBar({super.key, required this.titleText, this.icon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white2,
      elevation: 5,
      shadowColor: AppColors.codGray.withValues(alpha: 0.5),
      centerTitle: true,
      title: icon != null
          ? Row(
              children: [
                SizedBox(width: 15.w),
                SvgPicture.asset(icon!),
                Text(titleText.tr(), style: AppTextTheme.labelMedium),
              ],
            )
          : Text(titleText.tr(), style: AppTextTheme.body1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
