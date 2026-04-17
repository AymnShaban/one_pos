part of '../invoice_collection_imports.dart';

abstract interface class InvoiceCollectionDataSource {
  Future<List<BondTypeModel>> getBondTypes();
  Future<List<BondTypeModel>> getBondTypesByBranch(int branchId);
  Future<List<Map<String, dynamic>>> getBranches();
  Future<List<Map<String, dynamic>>> getCurrencies();
  Future<List<Map<String, dynamic>>> getPayWays();
  Future<VoucherResponseModel> addCollection(CollectionRequestModel request);
  Future<VoucherResponseModel> editCollection(CollectionRequestModel request);
}

class InvoiceCollectionDataSourceImpl implements InvoiceCollectionDataSource {
  final String _privateKey;
  final String _publicKey;
  final String _baseUrl;
  final String _userId;
  final String _ipAddress;
  final String _userNameServer;
  final String _passwordServer;
  final String _databaseName;

  InvoiceCollectionDataSourceImpl({
    required String privateKey,
    required String publicKey,
    required String baseUrl,
    required String userId,
    required String ipAddress,
    required String userNameServer,
    required String passwordServer,
    required String databaseName,
  })  : _privateKey      = privateKey,
        _publicKey       = publicKey,
        _baseUrl         = baseUrl,
        _userId          = userId,
        _ipAddress       = ipAddress,
        _userNameServer  = userNameServer,
        _passwordServer  = passwordServer,
        _databaseName    = databaseName;

  // ── Factory from Hive ─────────────────────────────────────────────────────
  factory InvoiceCollectionDataSourceImpl.fromHive() {
    final hive = HiveServiceImpl.instance;
    return InvoiceCollectionDataSourceImpl(
      privateKey:     hive.getPrivateKey()     ?? '',
      publicKey:      hive.getPublicKey()      ?? '',
      baseUrl:        hive.getBaseUrl()        ?? '',
      userId:         hive.getUserId()?.toString() ?? '',
      ipAddress:      hive.getIpAddress()      ?? '',
      userNameServer: hive.getServerUserName() ?? '',
      passwordServer: hive.getServerPassword() ?? '',
      databaseName:   hive.getDatabaseName()   ?? '',
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _decrypt(dynamic data) => decrypt(data, _privateKey, _publicKey);

  String _encrypt(Map<String, dynamic> data) =>
      encryptData(data, _privateKey, _publicKey);

  String get _apiBase => 'http://$_ipAddress/$_baseUrl';

  Future<dynamic> _get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    final dio = Dio(BaseOptions(baseUrl: _apiBase));
    final response = await dio.get(endpoint, queryParameters: queryParams);
    return response.data;
  }

  Future<dynamic> _post(String endpoint, dynamic data) async {
    final dio = Dio(BaseOptions(baseUrl: _apiBase));
    final response = await dio.post(endpoint,
        data: jsonEncode(data),
        options: Options(
            headers: {'Content-Type': 'application/json'}));
    return response.data;
  }

  Future<dynamic> _put(String endpoint, dynamic data) async {
    final dio = Dio(BaseOptions(baseUrl: _apiBase));
    final response = await dio.put(endpoint,
        data: jsonEncode(data),
        options: Options(
            headers: {'Content-Type': 'application/json'}));
    return response.data;
  }

  List<Map<String, dynamic>> _decryptList(dynamic data) {
    final decrypted = _decrypt(data);
    return (jsonDecode(decrypted) as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  // ── Endpoints ─────────────────────────────────────────────────────────────
  @override
  Future<List<BondTypeModel>> getBondTypes() async {
    final data = await _get(EndPoints.getReceiptsVouchersTypes);
    return _decryptList(data)
        .map((e) => BondTypeModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<BondTypeModel>> getBondTypesByBranch(int branchId) async {
    final data = await _get(
      EndPoints.getReceiptsVouchersTypesByBranch,
      queryParams: {'BranchID': branchId},
    );
    return _decryptList(data)
        .map((e) => BondTypeModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getBranches() async {
    final data = await _get(
      EndPoints.getCompanyBranchesByUser,
      queryParams: {
        'UserID':        _userId,
        'serverName':    _ipAddress,
        'UserName':      _userNameServer,
        'UserPassword':  _passwordServer,
        'DBName':        _databaseName,
      },
    );
    return _decryptList(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getCurrencies() async {
    final data = await _get(EndPoints.getCurrencies);
    return _decryptList(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getPayWays() async {
    final data = await _get(EndPoints.getPayWays);
    return _decryptList(data);
  }

  @override
  Future<VoucherResponseModel> addCollection(
      CollectionRequestModel request) async {
    final encrypted = _encrypt(request.toMap());
    final data = await _post(EndPoints.invoiceCollecting, encrypted);
    final decrypted = _decrypt(data);
    final json = jsonDecode(decrypted) as Map<String, dynamic>;
    return VoucherResponseModel.fromJson(json);
  }

  @override
  Future<VoucherResponseModel> editCollection(
      CollectionRequestModel request) async {
    final encrypted = _encrypt(request.toMap());
    final data = await _put(EndPoints.updateInvoiceCollecting, encrypted);
    final decrypted = _decrypt(data);
    final json = jsonDecode(decrypted) as Map<String, dynamic>;
    return VoucherResponseModel.fromJson(json);
  }
}