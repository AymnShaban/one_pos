import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

abstract interface class AppTextTheme {
  static final TextStyle _baseStyle = TextStyle(
    fontFamily: 'Hacen',
    // letterSpacing: 0.5,
    height: 1.5,
    color: AppColors.black,
  );

  static TextStyle heading1 = _baseStyle.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading2 = _baseStyle.copyWith(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle body1 = _baseStyle.copyWith(fontSize: 16.sp);
  static TextStyle body1Bold = _baseStyle.copyWith(fontSize: 16.sp,fontWeight: FontWeight.w900);

  static TextStyle body2 = _baseStyle.copyWith(fontSize: 14.sp);
  static TextStyle body2Bold = _baseStyle.copyWith(fontSize: 14.sp,fontWeight: FontWeight.bold);

  static TextStyle caption = _baseStyle.copyWith(fontSize: 12.sp);
  static TextStyle captionBold = _baseStyle.copyWith(fontSize: 12.sp ,fontWeight: FontWeight.bold);

  static TextStyle bodyLarge = _baseStyle.copyWith(fontSize: 30.sp);

  static TextStyle bodyMedium = _baseStyle.copyWith(fontSize: 25.sp);

  static TextStyle bodySmall = _baseStyle.copyWith(fontSize: 14.sp);

  static TextStyle labelLarge = _baseStyle.copyWith(fontSize: 14.sp);

  static TextStyle labelMedium = _baseStyle.copyWith(fontSize: 12.sp);
  static TextStyle labelSmall6 = _baseStyle.copyWith(fontSize: 6.sp);
  static TextStyle labelSmall8 = _baseStyle.copyWith(fontSize: 8.sp);
  static TextStyle labelSmall9 = _baseStyle.copyWith(fontSize: 9.sp);
  static TextStyle labelSmall9Bold = _baseStyle.copyWith(fontSize: 9.sp,fontWeight: FontWeight.bold);
  static TextStyle labelMedium11 = _baseStyle.copyWith(fontSize: 11.sp);
  static TextStyle labelMedium11Bold = _baseStyle.copyWith(fontSize: 11.sp,fontWeight: FontWeight.bold);
  static TextStyle labelSmall = _baseStyle.copyWith(fontSize: 10.sp);
  static TextStyle titleLarge = _baseStyle.copyWith(fontSize: 22.sp);
  static TextStyle titleLargeBold = _baseStyle.copyWith(fontSize: 22.sp,fontWeight: FontWeight.bold);

  static TextStyle titleMedium = _baseStyle.copyWith(fontSize: 20.sp);

  static TextStyle titleSmall = _baseStyle.copyWith(fontSize: 18.sp);
  static TextStyle titleSmallBold = _baseStyle.copyWith(fontSize: 18.sp,fontWeight: FontWeight.bold);

  static TextStyle displayLarge = _baseStyle.copyWith(fontSize: 34.sp);

  static TextStyle displayMedium = _baseStyle.copyWith(fontSize: 28.sp);

  static TextStyle displaySmall = _baseStyle.copyWith(fontSize: 22.sp);

  static TextStyle headlineLarge = _baseStyle.copyWith(
    fontSize: 35.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headlineMedium = _baseStyle.copyWith(fontSize: 28.sp);

  static TextStyle headlineSmall = _baseStyle.copyWith(fontSize: 24.sp);
}
