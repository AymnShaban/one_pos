import '../../../core/helper/helper.dart';
import '../../core/services/service_locator/services_imports.dart';
import '../auth/bloc/activation_bloc/activation_bloc.dart';
import '../auth/bloc/activation_bloc/activation_event.dart';
import '../auth/bloc/log_in_bloc/log_in_bloc.dart';
import '../auth/presentation/screens/activation_screen.dart';
import '../auth/presentation/screens/login_screen.dart';
import '../main/home/home_imports.dart';

Route _activationRoute() => MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => getIt<ActivationBloc>(),
        child: const ActivationScreen(),
      ),
    );

Route _loginRoute() => MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => getIt<LoginBloc>(),
        child: const LoginScreen(),
      ),
    );

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final hive   = HiveServiceImpl.instance;
    final config = hive.getAppConfig();
    final userId = hive.getUserId();

    // ── Case 1: Never activated → open the activation screen directly ───────
    if (config == null) {
      Navigator.pushReplacement(context, _activationRoute());
      return;
    }

    // ── Case 2: Activated but not logged in ──────────────────────────────────
    if (userId == null) {
      Navigator.pushReplacement(context, _loginRoute());
      return;
    }

    // ── Case 3: Activated + logged in → check device still active ───────────
    final activationBloc = getIt<ActivationBloc>();
    await activationBloc.initDevice(context);
    activationBloc.add(const CheckDeviceActivation());

    // Listen for the result once
    await for (final state in activationBloc.stream.take(1)) {
      if (!mounted) return;

      final isActive = state.metadata['isActive'] == true;

      if (!isActive) {
        // Device deactivated remotely — back to activation
        Navigator.pushReplacement(context, _activationRoute());
        return;
      }

      // All good — go to main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<HomeBloc>()..add(const InitHome()),
              ),
              BlocProvider(
                create: (_) => getIt<NavBloc>(),
              ),
            ],
            child: const MainScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white4,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(scale: value, child: child),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Image.asset(AppAssets.appLogo, height: 250),
          ),
        ),
      ),
    );
  }
}