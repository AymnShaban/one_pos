import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/feature/splash/splash_screen.dart';
import 'core/local/hive_service_impl.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/service_locator/services_imports.dart';
import 'core/theme/light_theme.dart';
import 'core/widgets/custom_language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await HiveServiceImpl.init();

  // ── Dummy setup — remove when backend is ready ──────────────────────────
  await _saveDummyConfigIfNeeded();
  // ────────────────────────────────────────────────────────────────────────

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:                    Colors.transparent,
      statusBarIconBrightness:           Brightness.dark,
      systemNavigationBarColor:          Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],
      path:           'assets/translation',
      fallbackLocale: const Locale('ar'),
      startLocale:    const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

// ── Dummy config — skips ActivationScreen, goes straight to LoginScreen ───────
Future<void> _saveDummyConfigIfNeeded() async {
  final hive = HiveServiceImpl.instance;

  // Only save once — don't overwrite if already set
  if (hive.getAppConfig() != null) return;

  await hive.saveActivationCode('DUMM-Y000-TEST-0001');
  await hive.saveAppConfig({
    'ConnectionID':      'DUMMY-CONNECTION-001',
    'DBDescription':     'المسيلة كلينك-2026',
    'DBName':            'TheOneClncPro009',
    'PassWord':          'Pass The#1ss',
    'Server':            '37.34.226.151',
    'UserName':          'sa',
    'PublicKey':         '8509e3dfec2bbd92',
    'PrivateKey':        '0998b85da6f7ae7c3b246d7fbf4c26a5',
    'Authorization':     'ODUwOWUzZGZlYzJiYmQ5MjpnWTBkWDRBVVMySFdsWUpWaG0yTnJEVWFvRmZVZzZEUkUzclVBRkp2b3lFPQ==',
    'Signature':         'gY0dX4AUS2HWlYJVhm2NrDUaoFfUg6DRE3rUAFJvoyE=',
    'LastLoginName':     'posaymn',
    'LastLoginPassword': 'Aa@12345',
    'BaseURL':           'TheOneAPI/api/',
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:      const Size(375, 812),
      minTextAdapt:    true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale:                  context.locale,
          supportedLocales:        context.supportedLocales,
          localizationsDelegates:  context.localizationDelegates,
          theme:                   AppThemeData.light(context),
          navigatorKey:            NavigationService.navigatorKey,
          scaffoldMessengerKey:    NavigationService.scaffoldMessengerKey,
          home:                    const SplashScreen(),
        );
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();