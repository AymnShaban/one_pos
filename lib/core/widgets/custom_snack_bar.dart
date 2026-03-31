import '../../core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import 'custom_language.dart';

void showCustomSnackBar(BuildContext context, String text) {
  if (context.mounted) {
    NavigationService.scaffoldMessengerKey.currentState?.showSnackBar(

      SnackBar(
        content: Center(
          child: Text(
            text,
            style: AppTextTheme.captionBold.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.mainAppColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        showCloseIcon: true,
      ),
    );
  }
}