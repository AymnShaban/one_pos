import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constant/end_points.dart';
import '../../../core/helper/helper.dart';
import '../../../core/widgets/custom_snack_bar.dart';
import '../basket/basket_imports.dart' show
    CustomerAccountModel,
    CustomerSearchDialog;
import '../invoice_setup/invoice_setup_imports.dart'
    show BranchBloc, BranchModel, LoadBranches, SelectBranchById;

// Models
part 'models/bond_type_model.dart';
part 'models/voucher_response_model.dart';
part 'models/collection_request_model.dart';
part 'models/collection_invoice_row_model.dart';

// Data source
part 'data_source/invoice_collection_data_source.dart';

// Blocs
part 'manager/invoice_collection_bloc/invoice_collection_bloc.dart';
part 'manager/invoice_collection_bloc/invoice_collection_event.dart';
part 'manager/invoice_collection_bloc/invoice_collection_states.dart';
part 'manager/invoice_search_bloc/invoice_search_bloc.dart';
part 'manager/invoice_search_bloc/invoice_search_event.dart';

// Screens / widgets
part 'presentation/screens/invoice_collection_screen.dart';
part 'presentation/screens/invoice_picker_screen.dart';
part 'presentation/widgets/collection_mobile_layout.dart';
