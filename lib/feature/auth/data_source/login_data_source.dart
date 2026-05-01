import '../../../../../core/helper/helper.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../models/activation_model.dart';
import '../models/customer_model.dart';


abstract interface class LoginDataSource {
  Future<Either<Failure, CustomerModel>> login({
    required String phone,
    required String password,
  });
}

const String _dummyUsername = 'posaymn';
const String _dummyPassword = 'Aa@12345';

final _dummyConfig = ActivationModel(
  connectionId:      'DUMMY-CONNECTION-001',
  dbDescription:     'المسيلة كلينك-2026',
  dbName:            'TheOneClncPro009',
  password:          'Pass The#1ss',
  server:            '37.34.226.151',
  userName:          'sa',
  publicKey:         '8509e3dfec2bbd92',
  privateKey:        '0998b85da6f7ae7c3b246d7fbf4c26a5',
  authorization:     'ODUwOWUzZGZlYzJiYmQ5MjpnWTBkWDRBVVMySFdsWUpWaG0yTnJEVWFvRmZVZzZEUkUzclVBRkp2b3lFPQ==',
  signature:         'gY0dX4AUS2HWlYJVhm2NrDUaoFfUg6DRE3rUAFJvoyE=',
  lastLoginName:     _dummyUsername,
  lastLoginPassword: _dummyPassword,
  baseUrl:           'TheOneAPI/api/',
);

// ── Dummy customer using the actual CustomerModel fields ──────────────────────
final _dummyCustomer = CustomerModel(
  customerId:    1,
  arabicName:    'أيمن شعبان',
  englishName:   'Aymn Shaban',
  customerPhone: _dummyUsername,   // phone field used as username
  lastName:      '',
  password:      _dummyPassword,
  email:         'posaymn@theonesystem.com',
  regionId:      0,
  regionName:    '',
  placeId:       0,
  districtName:  '',
  streetName:    '',
  gada:          '',
  houseNo:       '',
  block:         '',
  floor:         '',
  apartment:     '',
  addressNotes:  '',
  customerAddress: '',
  billValue:     0.0,
  paymentMethod: '',
  deliveryValue: 0.0,
  districtName2: '',
  districtEName2: '',
  token:         'DUMMY_TOKEN_001',
  mapCustomerAddress: '',
  mapPlaceId:    '',
  addressId:     '0',
  customerLastName: '',
);

class LoginDataSourceImpl implements LoginDataSource {
  @override
  Future<Either<Failure, CustomerModel>> login({
    required String phone,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate credentials
    if (phone.trim() != _dummyUsername ||
        password.trim() != _dummyPassword) {
      return Left(
        ServerFailure(
          message: 'auth.please_check_your_phone_number_and_password',
        ),
      );
    }

    try {
      final hive = HiveServiceImpl.instance;

      // Save activation config → makes all data sources work
      await hive.saveActivationCode('DUMM-Y000-TEST-0001');
      await hive.saveAppConfig(_dummyConfig.toJson());

      // Save user session
      await hive.saveLoggedInUser(_dummyCustomer.toJson());
      await hive.saveUserId(_dummyCustomer.customerId);
      await hive.saveSellerName(
        _dummyCustomer.arabicName ?? _dummyCustomer.englishName ?? '',
      );
      await hive.saveHaveDiscount(1);

      // Cache in GetIt
      getIt<IUserCache>().cacheUserModel(_dummyCustomer);

      return Right(_dummyCustomer);
    } catch (e) {
      return Left(
        ParsingFailure(
          message: 'Failed to process dummy login: ${e.toString()}',
        ),
      );
    }
  }
}