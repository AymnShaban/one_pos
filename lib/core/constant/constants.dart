
import '../local/hive_service_impl.dart';
import '../services/service_locator/services_imports.dart';

String? currentLang = 'ar';
int customerId = getIt.get<IUserCache>().getUserModel()?.employeeId ?? 0;
String customerPhone = getIt.get<IUserCache>().getUserModel()?.employeeId.toString() ??  "";
String customerName = getIt.get<IUserCache>().getUserModel()?.employeeName ??  "";
