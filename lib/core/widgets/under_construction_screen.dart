import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';
import '../theme/app_text_theme.dart';

/// Reusable "this screen is under construction" placeholder.
///
/// Embeddable inside a tab body (just drop it into the scaffold or a
/// `SliverFillRemaining`); when [showAppBar] is true it scaffolds itself
/// into a full route with a back button — handy when navigating to a
/// not-yet-built feature from an action card.
///
/// Translation keys it pulls (already in the bundles): `common.under_construction`,
/// `common.page_under_development`. Pass [title]/[subtitle] to override
/// for a specific feature ("Coming in v1.2", etc.).
class UnderConstructionScreen extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData icon;
  final bool showAppBar;

  const UnderConstructionScreen({
    super.key,
    this.title,
    this.subtitle,
    this.icon = Icons.construction_rounded,
    this.showAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                color: AppColors.mainAppColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48.sp, color: AppColors.mainAppColor),
            ),
            SizedBox(height: 20.h),
            Text(
              title ?? 'common.under_construction'.tr(),
              textAlign: TextAlign.center,
              style: AppTextTheme.titleLarge.copyWith(
                color: const Color(0xff1A1A1A),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle ?? 'common.page_under_development'.tr(),
              textAlign: TextAlign.center,
              style: AppTextTheme.caption.copyWith(
                color: const Color(0xff8A8F99),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );

    if (!showAppBar) return body;

    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          title ?? 'common.under_construction'.tr(),
          style: AppTextTheme.titleLarge.copyWith(color: Colors.white),
        ),
      ),
      body: body,
    );
  }
}
