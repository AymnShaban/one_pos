import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:one_pos/feature/main/basket/basket_imports.dart';
import 'package:one_pos/feature/main/settings/settings_imports.dart';

import '../../../core/constant/end_points.dart';
import '../../../core/helper/helper.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../../../core/widgets/under_construction_screen.dart';
import '../../barren/presentation/cubit/invoice_cubit.dart';
import '../../barren/presentation/screens/home_screen.dart'
    show BarrenStockTakingScreen;
import '../reports/reports_imports.dart';
import '../sales/sales_imports.dart';

part 'presentation/screens/home_tab.dart';
part 'presentation/screens/invoices_placeholder.dart';
part 'presentation/screens/main_screen.dart';
part 'manager/bottom_nav_bloc/bottom_nav_bloc.dart';
part 'manager/bottom_nav_bloc/bottom_nav_event.dart';
part 'manager/bottom_nav_bloc/bottom_nav_states.dart';
part 'models/home_stats_model.dart';
part 'models/dashboard_balances_model.dart';
part 'data_source/dashboard_data_source.dart';
part 'manager/home_bloc/home_bloc.dart';
part 'manager/home_bloc/home_event.dart';