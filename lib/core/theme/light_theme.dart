import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';
import 'app_text_theme.dart';

mixin AppThemeData on ThemeData {
  static ThemeData light(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.mainAppColor,
    primaryColorLight: AppColors.mainAppColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.mainAppColor),
      backgroundColor: Colors.white,
      titleTextStyle: AppTextTheme.headlineLarge,
      surfaceTintColor: Colors.white,
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.teal,
      selectionColor: Colors.teal,
      selectionHandleColor: Colors.teal,
    ),
    fontFamily: 'Alexandria',
    textTheme:
        TextTheme(
          bodyLarge: AppTextTheme.bodyLarge,
          bodyMedium: AppTextTheme.bodyMedium,
          bodySmall: AppTextTheme.bodySmall,
          labelLarge: AppTextTheme.labelLarge,
          labelMedium: AppTextTheme.labelMedium,
          labelSmall: AppTextTheme.labelSmall,
          titleLarge: AppTextTheme.titleLarge,
          titleMedium: AppTextTheme.titleMedium,
          titleSmall: AppTextTheme.titleSmall,
          displayLarge: AppTextTheme.displayLarge,
          displayMedium: AppTextTheme.displayMedium,
          displaySmall: AppTextTheme.displaySmall,
          headlineLarge: AppTextTheme.headlineLarge,
          headlineMedium: AppTextTheme.headlineMedium,
          headlineSmall: AppTextTheme.headlineSmall,
        )..apply(
          bodyColor: AppColors.mainAppColor,
          displayColor: AppColors.mainAppColor,
          fontFamily: 'Alexandria',
        ),

    inputDecorationTheme: InputDecorationTheme(
      errorStyle: AppTextTheme.bodyMedium.copyWith(
        color: AppColors.mainAppColor,
        fontSize: 20.sp,
      ),
    ),
    // textSelectionTheme: ,
    iconTheme: IconThemeData(color: AppColors.mainAppColor),
  );
}
