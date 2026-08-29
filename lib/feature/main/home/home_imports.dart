import 'package:easy_localization/easy_localization.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:one_pos/feature/main/basket/basket_imports.dart' hide PayWaysBloc;
import 'package:one_pos/feature/main/home/presentation/widgets/daily_operation_card.dart';


import 'package:one_pos/feature/main/settings/settings_imports.dart';
import 'package:one_pos/feature/main/main_reports/invoices_profit/invoice_profit_imports.dart' hide LoadCurrencies;

import '../../../core/responsive/app_responsive.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../../../core/widgets/bunsing_ball_refresh_indecator.dart';
import '../../../core/widgets/under_construction_screen.dart';

import '../../barren/presentation/cubit/invoice_cubit.dart';
import '../../barren/presentation/screens/home_screen.dart'
    show BarrenStockTakingScreen;



import '../customer_account_statement/presentation/screens/customer_account_statement_screen.dart';
import '../entries/entries_imports.dart';

import '../invoice_setup/invoice_setup_imports.dart';
import '../main_reports/branch_profit_report/branch_profit_import.dart';
import '../main_reports/expense_analysis/expense_analysis_imports.dart';


import '../main_reports/item_movement_balance/presentation/screens/item_movement_balance_screen.dart';
import '../main_reports/item_profit_report/data/datasource/item_profit_datasource.dart';
import '../main_reports/item_profit_report/presentation/manager/item_profit_bloc.dart';
import '../main_reports/item_profit_report/presentation/screen/item_profit_filters_screen.dart';
import '../main_reports/items_movement/presentation/screens/items_movement_report_screen.dart';
import '../main_reports/live_sales_report/live_sales_report_imports.dart'
    show LiveSalesReportScreen;
import '../main_reports/receipts_and_payments_movement_report/presentation/manager/delivered_to_bloc/delivered_to_bloc.dart';
import '../main_reports/receipts_and_payments_movement_report/presentation/manager/delivered_to_bloc/delivered_to_event.dart';
import '../main_reports/receipts_and_payments_movement_report/presentation/manager/received_from_bloc/received_from_bloc.dart';
import '../main_reports/receipts_and_payments_movement_report/presentation/manager/received_from_bloc/received_from_event.dart';
import '../main_reports/shared/report_sources/presentation/manager/report_source_bloc.dart';
import '../main_reports/shared/report_sources/presentation/manager/report_source_event.dart';
import '../main_reports/receipts_and_payments_movement_report/presentation/manager/vouchers_report_bloc/vouchers_bloc.dart';
import '../main_reports/receipts_and_payments_movement_report/presentation/screen/receipts_and_payments_movement_report_filters_screen.dart' hide LoadCurrencies;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '../main_reports/revenue_analysis/revenue_analysis_import.dart';
import '../reports/reports_imports.dart';
import '../sales/sales_imports.dart';



import 'package:one_pos/feature/main/main_reports/shared/branches/branches_import.dart'
as branches;


import 'manager/home_bloc/reports_visibility_event.dart';
import 'manager/today_bills_bloc/daily_operation_bloc.dart';
import 'manager/today_bills_bloc/daily_operation_event.dart';
import 'models/daily_operation_model.dart';
// Models
part 'models/home_stats_model.dart';
part 'models/dashboard_balances_model.dart';


// Data Source
part 'data_source/dashboard_data_source.dart';
part 'data_source/daily_operation_datasource.dart';

// Bloc
part 'manager/home_bloc/home_bloc.dart';
part 'manager/home_bloc/home_event.dart';

part 'manager/bottom_nav_bloc/bottom_nav_bloc.dart';
part 'manager/bottom_nav_bloc/bottom_nav_event.dart';
part 'manager/bottom_nav_bloc/bottom_nav_states.dart';


part 'models/low_stock_item_model.dart';
part 'models/top_selling_item_model.dart';

part 'data_source/low_stock_datasource.dart';
part 'data_source/top_selling_datasource.dart';
part 'presentation/screens/home_tab.dart';
part 'presentation/screens/main_screen.dart';
part 'presentation/screens/invoices_placeholder.dart';

part 'manager/low_stock_bloc/low_stock_bloc.dart';
part 'manager/low_stock_bloc/low_stock_event.dart';

part 'manager/top_selling_bloc/top_selling_bloc.dart';
part 'manager/top_selling_bloc/top_selling_event.dart';

part 'presentation/widgets/low_stock_widget.dart';
part 'presentation/widgets/top_selling_widget.dart';