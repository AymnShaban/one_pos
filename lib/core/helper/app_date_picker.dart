import 'helper.dart';


class AppDatePicker {
  const AppDatePicker._();

  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final effectiveFirstDate = firstDate ?? DateTime(2000);
    final effectiveLastDate = lastDate ?? DateTime(2100);

    // Make sure the initial date is inside the allowed range.
    final today = DateTime.now();

    final effectiveInitialDate = initialDate ?? today;

    final safeInitialDate = effectiveInitialDate.isBefore(
      effectiveFirstDate,
    )
        ? effectiveFirstDate
        : effectiveInitialDate.isAfter(effectiveLastDate)
        ? effectiveLastDate
        : effectiveInitialDate;

    return showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,

      builder: (context, child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.mainAppColor,
              onPrimary: AppColors.whiteColor,
              surface: AppColors.whiteColor,
              onSurface: AppColors.textDark,
            ),

            // ⭐ TextField الخاص بالإدخال اليدوي
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.brandLight,

              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.line,
                  width: 1,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.line,
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.mainAppColor,
                  width: 1.5,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.red,
                  width: 1,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.red,
                  width: 1.5,
                ),
              ),

              labelStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13.sp,
              ),

              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14.sp,
              ),

              errorStyle: TextStyle(
                color: AppColors.red,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            // ⭐ شكل النص داخل input
            textTheme: theme.textTheme.copyWith(
              bodyLarge: TextStyle(
                color: AppColors.textDark,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.whiteColor,
              surfaceTintColor: Colors.transparent,

              // Header
              headerBackgroundColor: AppColors.mainAppColor,
              headerForegroundColor: AppColors.whiteColor,

              headerHeadlineStyle: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),

              headerHelpStyle: TextStyle(
                color: AppColors.whiteColor.withValues(alpha: 0.85),
                fontSize: 13.sp,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),

              // Years
              yearStyle: TextStyle(
                color: AppColors.textDark,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),

              yearForegroundColor:
              WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.mainAppColor;
                  }

                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.textMuted.withValues(
                      alpha: 0.4,
                    );
                  }

                  return AppColors.textDark;
                },
              ),

              yearBackgroundColor:
              WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.brandLight;
                  }

                  return Colors.transparent;
                },
              ),

              // Weekdays
              weekdayStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),

              // Days
              dayStyle: TextStyle(
                color: AppColors.textDark,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),

              dayForegroundColor:
              WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.textMuted.withValues(
                      alpha: 0.4,
                    );
                  }

                  if (states.contains(WidgetState.selected)) {
                    return AppColors.whiteColor;
                  }

                  return AppColors.textDark;
                },
              ),

              dayBackgroundColor:
              WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.mainAppColor;
                  }

                  return Colors.transparent;
                },
              ),

              // ⭐ Today
              todayForegroundColor:
              WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.whiteColor;
                  }

                  return AppColors.mainAppColor;
                },
              ),

              todayBackgroundColor:
              WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.mainAppColor;
                  }

                  return Colors.transparent;
                },
              ),

              todayBorder: BorderSide(
                color: AppColors.mainAppColor,
                width: 1.5,
              ),

              // Buttons
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: AppColors.mainAppColor,
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

