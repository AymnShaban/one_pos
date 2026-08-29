import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/feature/auth/presentation/screens/login_screen.dart';
import 'package:one_pos/feature/splash/splash_screen.dart';
import 'core/local/hive_service_impl.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/service_locator/services_imports.dart';
import 'core/theme/light_theme.dart';
import 'core/widgets/custom_language.dart';
import 'feature/auth/bloc/log_in_bloc/log_in_bloc.dart';
import 'feature/main/home/home_imports.dart';
import 'feature/main/home/manager/today_bills_bloc/daily_operation_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await HiveServiceImpl.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
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
      child:  DevicePreview(
  enabled: !kReleaseMode,
  builder: (context) =>
            const MyApp()

          ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Device Preview
          useInheritedMediaQuery: kDebugMode,
          locale: kDebugMode
              ? DevicePreview.locale(context)
              : context.locale,

          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          builder: kDebugMode
              ? DevicePreview.appBuilder
              : null,

          theme: AppThemeData.light(context),

          navigatorKey: NavigationService.navigatorKey,
          scaffoldMessengerKey:
          NavigationService.scaffoldMessengerKey,

          home: BlocProvider(
            create: (_) => getIt<LoginBloc>(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<HomeBloc>(),
                ),
                BlocProvider(
                  create: (_) => getIt<DailyOperationsBloc>(),
                ),
                BlocProvider<TopSellingBloc>(
                  create: (_) => getIt<TopSellingBloc>(),
                ),
                BlocProvider<LowStockBloc>(
                  create: (_) => getIt<LowStockBloc>(),
                ),
                BlocProvider(
                  create: (_) => getIt<NavBloc>(),
                ),
              ],
              child: const SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}



final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();