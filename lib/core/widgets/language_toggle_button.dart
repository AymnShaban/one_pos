import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../feature/auth/presentation/screens/login_screen.dart';
import '../constant/app_colors.dart';

class LanguageDropdownSection extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final String? labelText;
  final EdgeInsets? padding;

  const LanguageDropdownSection({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.labelText,
    this.padding,
  });

  String _getLanguageLabel(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return '🇸🇦';
      case 'en':
        return '🇬🇧';
      case 'fr':
        return '🇫🇷';
      default:
        return '🇬🇧';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor ?? Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentLang,
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: iconColor ?? AppColors.mainAppColor,
            ),
            dropdownColor: backgroundColor ?? Colors.white,
            items: [
              DropdownMenuItem(
                value: 'ar',
                child: Row(
                  children: [
                    Text(
                      _getLanguageFlag('ar'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      _getLanguageLabel('ar'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor ?? Colors.black87,
                        fontWeight: currentLang == 'ar'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Text(
                      _getLanguageFlag('en'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      _getLanguageLabel('en'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor ?? Colors.black87,
                        fontWeight: currentLang == 'en'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'fr',
                child: Row(
                  children: [
                    Text(
                      _getLanguageFlag('fr'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      _getLanguageLabel('fr'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor ?? Colors.black87,
                        fontWeight: currentLang == 'fr'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (String? newLang) {
              if (newLang != null && newLang != currentLang) {
                context.setLocale(Locale(newLang));
                Navigator.push(context, LoginScreen.route());
              }
            },
          ),
        ),
      ),
    );
  }
}


