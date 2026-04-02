import '../../../../../core/helper/helper.dart';
import '../main/home/manager/bottom_nav_bloc/bottom_nav_bloc.dart';
import '../main/home/manager/home_bloc/home_bloc.dart';
import '../main/home/manager/home_bloc/home_event.dart';
import '../main/home/presentation/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState;

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => getIt<HomeBloc>()..add(InitHome()),
                  ),
                  BlocProvider(
                    create: (_) => getIt<NavBloc>(),
                  ),
                ],
                child: MainScreen(),
              );
            },
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white4,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 4),
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
