
import 'constants.dart';

class EndPoints {

  // mazyad
  static  String baseUrl = "http://78.89.159.126:9494/TheOneERPAPI";
  // getIt<HiveServiceImpl>().getBaseUrl()??
  static const String logIn = '/api/Auth/login';

  // Home dashboard — sales/expenses totals + daily/monthly series.
  static const String getDashboardBalances = '/api/Dashboard/balances';

  // Live Sales report — POST with the body shape in
  // [SalesMovementsReportRequest]; returns one or more pages with sums +
  // line rows. Used by the "المبيعات الحية" screen.
  static const String salesMovementsReport = '/api/SalMov1Reports';


  // ── Existing endpoints ────────────────────────────────
  static const String register = "/api/Customer/AddCustomer";
  static const String getAllCustomersByName = '/api/Accounts/GetAllCustomersAccountByName';


  static String productDetails = "/api/Product/GetProductById";
  static String addToBasket = "/api/Product/AddSalesBasket";
  static String deleteOneItemFromBasket = "/api/Product/DeleteSalesBasket";
  static String getCustomerBasket = "/api/Product/GetCustomerSalesBasket";
  static String addOrder = "/api/Order";
  static String getOrdersDetails = "/api/Order/GetOrderProductsByCustomerID";

  static const String addNewAddress = "/api/Customer/AddCustomerAddress";
  static const String addFavorite = "/api/Customer/AddCustomerProduct";

  static const String deleteFavorite = "/api/Customer/DeleteCustomerProduct";
  static const String getFavorite = "/api/Customer/GetCustomerProducts";
  static const String getPreviousOrders = "/api/Order/GetOrdersByCustomerID";
  static String deleteAccount = "/api/Customer/DeleteCustomerByCustomerID";
  static const String privacyAndPlo = "/api/Privacy";
  static const String savedAddresses = "/api/Customers/GetCustomerAddress";
  static const String deleteAddress = "/api/Customer/DeleteCustomerAddress";
  static String changePassword = "/api/Customer/ChangePassword";
  static const String aboutUS = "/api/AboutUs";

  /// todo sendVerificationCode
  static const String sendVerificationCode = "اااا";

  //.
  //.
  static String newsMarquee = "/api/News";

  //.
  // get areas
  static String getAreas = "/api/Areas";
  static String getAreaByGovernorateId = "/api/Areas/GetAreaByGovernorateId";

  static const String updateUser = "/user/update";
  static const String governorates = "/api/Governorates";

  static String offerOne = "/api/Offer1";
  static String offerTwo = "/api/Offer2";
  static String offerThree = "/api/Offer3";
  static String offerFour = "/api/Offer4";
  static String offerFive = "/api/Offer5";
  static String allOffer = "/api/Offers";

  static String bannerTwo = "/api/Baner2";
  static String bannerThree = "/api/Baner3";

  static String previousTrackingOrdersByPhone =
      "/api/Order/GetCurrentOrdersByCustomerPhone/$customerPhone";
  static String customerIsActive =
      "/api/Customers/CustomerIsActive?CustomerPhone=$customerPhone";

  static String updateProfileData = "/api/Customer/UpdateCustomer";
  static String profileData =
      "/api/Customers/GetCustomer?CustomerPhone=$customerPhone";

  static String previousOrdersItem({required int itemId}) =>
      "/api/Order/GetOrderProducts/$itemId?CustomerPhone=$customerPhone";

  static String couponsDiscountCode(var discountCode) =>
      "/api/Coupons/GetByCode/$discountCode?CustomerPhone=$customerPhone";

  static String bannerProductByIdImage({required int id}) =>
      "/api/BannerItems1?ImageName=$id&CustomerID=$customerPhone'";

  // Invoices
  static const String getInvoices = "/api/Invoices";
  static const String deleteInvoice = "/api/Invoices/Delete";

  // Reports
  static const String getReport = "/api/Reports";

  // end_points.dart — add these
  static const String getMainCategory = '/api/Category/GetMainCategory';
  static const String getSubCategory = '/api/Category/GetSubCategory';
  static const String getProductsByCategory =
      '/api/Product/GetByCategory';
  static String subCategoryProducts =
      "/api/Product/GetProductsByPatternIdAndGroupIdV1";

  static const String searchProducts = '/api/Product/SearchProducts';
  static const String searchProductByBarcode =
      '/api/Product/SearchProductByBarcode';
  static const String getLastInvoiceByPattern =
      '/api/SalesInvoice/GetLastInvoiceByInvoiceID';
  static const String createSalesInvoice = '/api/SalesInvoice/Create';
  static const String editSalesInvoice = '/api/SalesInvoice/Edit';
  static const String getPayWays = '/api/PayWays';
  // Purchase-invoice-specific pattern list. Submission itself reuses the sales
  // create endpoint above — only the JSON `PurchaseInvoicePayWays` key differs.
  static const String getPurchasesTypes =
      '/api/InvoiceSetting/GetPurchasesTypes';

  // Invoice Collection
  // Single endpoint that returns every invoice pattern across all categories
  // (purchases / sales / transfers / quotes & orders). Clients filter the
  // result client-side via `InvoicePatternModel.patternType` / `category`.
  static const String getInvoicePatterns = '/api/InvoiceSetting/GetAllTypes';
  /// Branch-scoped patterns — preferred over `getInvoicePatterns` because
  /// the server already filters by branch. Query: `?branchId={id}`.
  static const String getInvoiceSettingByBranch =
      '/api/BSR/GetInvoiceSettingByBranchID';
  static const String getQuotePatterns = '/api/InvoicePattern/GetQuoteByBranch';
  static const String getCurrencies = '/api/Currency/GetCurrencies';
 // [{"CurrencyID":1,"CurrencyName":"دينار كويتي","CurrencyEName":"Kuwait Dinar","PartName":"فلس","PartEName":"Fils","PartPrecition":1000,"Rate":1.0,"CurrencySymbol":"د.ك.","TotCurrencyName":"دنانير","TotCurrencyEName":"Dinars","TotPartName":"فلسات","TotPartEName":"Fils","PricesDigits":"0.000"}]

  static const String getReceiptsVouchersTypesByBranch =
      'api/VoucherSettings/GetReceiptsVouchersTypesByBranchID';

  // Branches list — no query parameters; server resolves the caller from
  // the Bearer JWT. Response: [{ id, braCode, braName, braEName,
  // braParent, currencyID, deactivated, codeAndArabicName,
  // codeAndEnglishName, … }, …].
  static const String getCompanyBranchesByUser =
      '/api/GBranch/GetCompanyBranchesByUserIDV2';

  static const String invoiceCollecting = 'api/Voucher/InvoiceCollecting';
  // Invoice picker for the collection screen — three search modes mirror
  // the old InvoiceSearchCubit.
  static const String getAllSalesInvoicesByCustomerId =
      'api/SalesInvoice/GetAllSalesInvoicesByCustomerID';
  static const String getSalesInvoiceByNumber =
      'api/SalesInvoice/GetSalesInvoiceByNumber';
  static const String getSalesInvoiceByCustomerName =
      'api/SalesInvoice/GetSalesInvoiceByCustomerName';

  static const String updateInvoiceCollecting =
      'api/Voucher/UpdateInvoiceCollecting';
  static const String getReceiptsVouchersTypes =
      'api/VoucherSettings/GetReceiptsVouchersTypes';
}
