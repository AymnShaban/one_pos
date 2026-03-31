import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static BuildContext? get context =>
      navigatorKey.currentState?.overlay?.context;

  static Future<dynamic> push(Widget page) {
    return navigatorKey.currentState!.push(
      CupertinoPageRoute(builder: (_) => page),
    );
  }

  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushReplacement(Widget page) {
    return navigatorKey.currentState!.pushReplacement(
      CupertinoPageRoute(builder: (_) => page),
    );
  }

  static Future<dynamic> pushReplacementNamed(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pop() {
    return navigatorKey.currentState!.pop();
  }

  static void popUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(
          (route) => route.settings.name == routeName,
    );
  }

  static void popWithResult<T>(T result) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  static Future<dynamic> pushAndRemoveUntil(Widget page) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showToast(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Cycle through languages: ar -> en -> fr -> ar
  static void changeLanguage() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      final currentLocale = context.locale;
      Locale newLocale;

      if (currentLocale.languageCode == 'ar') {
        newLocale = const Locale('en');
      } else if (currentLocale.languageCode == 'en') {
        newLocale = const Locale('fr');
      } else {
        newLocale = const Locale('ar');
      }

      context.setLocale(newLocale);
    }
  }

  // Set specific language
  static void setLanguage(String languageCode) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.setLocale(Locale(languageCode));
    }
  }

  static Locale getCurrentLocale() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return context.locale;
    }
    // Fallback locale
    return const Locale('en', 'US');
  }

  // Get language display name
  static String getLanguageDisplayName(String languageCode) {
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

  // Get next language display name (for button text)
  static String getNextLanguageDisplayName() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      final currentLocale = context.locale.languageCode;

      if (currentLocale == 'ar') {
        return 'En'; // Next is English
      } else if (currentLocale == 'en') {
        return 'Fr'; // Next is French
      } else {
        return 'ع'; // Next is Arabic (short form)
      }
    }
    return 'En';
  }
}