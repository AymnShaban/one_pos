import 'dart:convert';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constant/end_points.dart';
import '../../../../core/helper/helper.dart';
import '../../invoice_setup/invoice_setup_imports.dart'
    show BranchBloc, BranchModel, LoadBranches;

// Models
part 'models/sales_movements_report_request.dart';
part 'models/sales_movements_report_response.dart';
part 'models/delegate_model.dart';

// Data source
part 'data_source/live_sales_report_data_source.dart';
part 'data_source/delegate_data_source.dart';

// Bloc
part 'manager/live_sales_report_bloc/live_sales_report_bloc.dart';
part 'manager/live_sales_report_bloc/live_sales_report_event.dart';
part 'manager/delegate_bloc/delegate_bloc.dart';
part 'manager/delegate_bloc/delegate_event.dart';

// Screens
part 'presentation/screens/live_sales_report_screen.dart';
