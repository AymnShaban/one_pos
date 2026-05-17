import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:one_pos/feature/main/basket/basket_imports.dart';
import 'package:one_pos/feature/main/home/presentation/widgets/action_card.dart';
import 'package:one_pos/feature/main/home/presentation/widgets/home_app_bar.dart';
import 'package:one_pos/feature/main/home/presentation/widgets/recent_activity_item.dart';
import 'package:one_pos/feature/main/home/presentation/widgets/stats_card.dart';
import 'package:one_pos/feature/main/home/presentation/widgets/welcome_card.dart';
import 'package:one_pos/feature/main/settings/settings_imports.dart';

import '../../../core/helper/helper.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../invoices/invoices_imports.dart';
import '../new_invoice/new_invoice_imports.dart';
import '../reports/reports_imports.dart';
import '../sales/sales_imports.dart';

part 'presentation/screens/home_tab.dart';
part 'presentation/screens/invoices_placeholder.dart';
part 'presentation/screens/main_screen.dart';
part 'manager/bottom_nav_bloc/bottom_nav_bloc.dart';
part 'manager/bottom_nav_bloc/bottom_nav_event.dart';
part 'manager/bottom_nav_bloc/bottom_nav_states.dart';
part 'models/home_stats_model.dart';
part 'manager/home_bloc/home_bloc.dart';
part 'manager/home_bloc/home_event.dart';