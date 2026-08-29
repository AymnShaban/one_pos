
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
  /// Customer account search scoped to the logged-in employee. Query params:
  /// `EmployeeID` (from the cached user) and `SearchKey`.
  static const String getCustomersAccountToEmployee =
      '/api/ACI/GetCustomersAccountToEmployee';


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

  static const String searchProducts = '/api/Product/GetAllProductsByFilterToAllGroups';
  static const String searchProductByBarcode =
      '/api/Product/SearchProductByBarcode';
  /// Single-product lookup by barcode. Barcode goes on the URL, not as a
  /// query param: `/api/Product/by-barcode/{barcode}`. Returns a single
  /// object with the minimal shape `{id, mtName, barcode, sale, qty}`.
  static const String productByBarcode = '/api/Product/by-barcode/';
  static const String getLastInvoiceByPattern =
      '/api/SalesInvoice/GetLastInvoiceByInvoiceID';
  static const String createSalesInvoice = '/api/SalesInvoice/PostInvoice';
  /// Full invoice payload for the details/edit view. Query: `invoiceId` +
  /// `invoiceNo` (both returned by the create response).
  static const String getInvoiceForEdit = '/api/SalesInvoice/GetInvoiceForEdit';
  static const String editSalesInvoice = '/api/SalesInvoice/Edit';
  static const String getPayWays = '/api/PayWay/GetPayWays';
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

  // Live Sales report — sellers ("delegates") multi-select. Query param
  // `search`; call with an empty value to get every delegate.
  static const String getDelegates = '/api/EtMovement/delegates';


// Invoice Profit

  static const String getInvoiceProfitParentAccounts =
      "/api/BillRevenue/parent-accounts";

  static const String getInvoiceProfitCustomers =
      "/api/BillRevenue/customers";

  static const String getInvoiceProfitEmployees =
      "/api/Employee";

  static const String getInvoiceProfitCostCenters =
      "/api/CostCenter/GetCostCenters";

  static const String getInvoiceProfitUsers =
      "/api/BillRevenue/users";

  static const String getInvoiceProfitCompanyBranches =
      "/api/GBranch";

  static const String getInvoiceProfitSources =
      "/api/BillRevenue/bill-sources";

  /// Invoice Profit Report Preview
  static const String getInvoiceProfitReport =
      "/api/BillRevenue/report";


  // ============================================================
  // EXPENSE ANALYSIS
  // ============================================================
  static const String expenseAccounts = '/api/ExpendedAnalysis/AllExpendedAccounts';
  static const String expenseReportDetails = '/api/ExpendedAnalysis/report-details';
  // ============================================================
  // REVENUE ANALYSIS
  // ============================================================
  static const String revenueAccounts = '/api/RevenuesAnalysis/AllRevenuesAccounts';
  static const String revenueReport = '/api/RevenuesAnalysis/BuildReports';

  // ============================================================
  // Profit Report
  // ============================================================
  static const String materialProfitReport = '/api/BillRevenue/Material-profit-report';

  static const String getDeliveredTo = '/api/EtMovement/DeliveredTo';
  static const String getReportSources = '/api/EtMovement/ReportSources';
  static const String getReceivedFrom = '/api/EtMovement/ReceivedFrom';
  static const String getVouchersReport = '/api/EtMovement/report';
  // ============================================================
  // daily_operation
  // ============================================================
  static const String getDailyOperation = '/api/BLI/GetTodayBills';
  // ============================================================
  // lowStockItems
  // ============================================================
  static const String getLowStockItems = '/api/MTI/GetLowStockItems';
  // ============================================================
  // topSellingItems
  // ============================================================
  static const String getTopSellingItems = '/api/MTI/GetTopSellingItems';

  // ============================================================



  // customer-statement
  // ============================================================
  static const String mainAccounts = '/api/CustomerAccounts/main-accounts';
  static const String customerSuppliers = '/api/CustomerAccounts/all-customers-suppliers';
  static const String customerStatementReport = '/api/CustomerAccounts/report';
  static const String getCustomerAccountReportSources = '/api/CustomerAccounts/report-sources';
 // static const String customerStatementReport = '/api/CustomerAccounts/report';

// ============================================================
// Branch Profit Report
// ============================================================
  static const String branchProfitReport = '/api/AccountMenu/GetReport';


  static const String getAllItems = '/api/ProductMnu/GetAllItems';
  static const String getGroups = '/api/Category/Groups';
  static const String getStores = '/api/Store/GetStores';
  // ============================================================
// Items Movement Report
// ============================================================
  static const String getReportSourcesMti = '/api/MTI/GetReportSources?arabic=true';
  static const String itemMovementReport = '/api/MTI/GetMaterialMotion';
 // ============================================================
// Get Group Motion
// ============================================================

  static const String itemMovementBalanceReport = '/api/ProductMnu/GetGroupMotion';


  /// GET /api/Entry/EtsTypes
  static const String getVoucherTypes =
      '/api/Entry/EtsTypes';

  /// GET /api/Entry/AllAccounts
  static const String getAllAccounts =
      '/api/Entry/AllAccounts';
static const String fillAccountList =
      '/api/Entry/FillAccountList';

  /// GET /api/Entry/EtsDetails/{frmNum}
  static const String getVoucherTypeDetails =
      '/api/Entry/EtsDetails';

  /// GET /api/Entry/Vouchers?vouchTypeId={id}
  static const String getVouchers =
      '/api/Entry/Vouchers';

  /// GET /api/Entry/GetVoucherById?frmNum={frmNum}&etNumber={etNumber}
  static const String getVoucherById =
      '/api/Entry/GetVoucherById';

  /// POST /api/Entry/PostEntry
  static const String postEntry =
      '/api/Entry/PostEntry';

  /// POST /api/EntryJour/SaveJournalEntry
  static const String saveJournalEntry =
      '/api/EntryJour/SaveJournalEntry';

  /// GET /api/EntryJour/EtsPatterns/by-voucher-type?vouchTypeId={id}
  static const String getEtsPatterns =
      '/api/EntryJour/EtsPatterns/by-voucher-type';
  static  String getAccountBalance({required num acId}) => '/api/Entry/AccountBalance/$acId';
}
