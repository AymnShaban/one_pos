import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../core/helper/helper.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../../auth/bloc/log_in_bloc/log_in_bloc.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../home/home_imports.dart';
import '../home/presentation/widgets/home_app_bar.dart';
part 'presentation/widgets/settings_section.dart';
part 'presentation/widgets/settings_tile.dart';
part 'presentation/widgets/system_info_card.dart';
part 'presentation/widgets/user_profile_card.dart';
part 'presentation/screens/settings_tab.dart';
part 'models/settings_model.dart';
part 'manager/settings_bloc/settings_bloc.dart';
part 'manager/settings_bloc/settings_event.dart';
