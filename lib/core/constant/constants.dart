
import '../local/hive_service_impl.dart';
import '../services/service_locator/service_locator.dart';

String? currentLang = 'ar';
int customerId = getIt.get<IUserCache>().getUserModel()?.customerId ?? 0;
String customerPhone = getIt.get<IUserCache>().getUserModel()?.customerPhone ??  "";
String customerName = getIt.get<IUserCache>().getUserModel()?.arabicName ??  "";
