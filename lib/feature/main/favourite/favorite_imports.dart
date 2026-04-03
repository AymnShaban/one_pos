import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constant/end_points.dart';
import '../../../core/helper/helper.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../../../core/widgets/custom_snack_bar.dart';
import '../../../core/widgets/failure_widget.dart';
import '../../../core/widgets/flexible_image.dart';
import '../../../core/widgets/pull_to_refresh.dart';

part 'manager/add_to_favorite_bloc/add_to_favorite_bloc.dart';
part 'manager/add_to_favorite_bloc/add_to_favorite_event.dart';
part 'data_source/favorite_data_source.dart';
part 'models/add_to_favorite_request.dart';
part 'models/favorite_model.dart';
part 'presentation/screens/favourites_screen.dart';
part 'presentation/widget/favourite_item.dart';