import 'package:get_it/get_it.dart';
import 'package:one_pos/feature/main/home/manager/home_bloc/home_bloc.dart';

import '../../../../feature/main/home/manager/bottom_nav_bloc/bottom_nav_bloc.dart';

class HomeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory<HomeBloc>(() => HomeBloc());
    getIt.registerFactory<NavBloc>(() => NavBloc());

 }
}