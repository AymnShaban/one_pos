import 'constants.dart';

class EndPoints {
  // test
  //   static const String baseUrl = "http://15.235.51.177/TheOneAPI";

  // mazyad
  static const String baseUrl = "http://78.89.159.126:9393/TheOneAPIMazyad";

  //
  // // alharamayn
  // static const String baseUrl = "http://78.89.159.126:9494/TheOneAPIElhrmeen";

  static String logIn(String customerPhone, String password) {
    return '/api/Customer/Login?CustomerPhone=$customerPhone&passWord=$password&Token=1111';
  }

  // ----- auth end--------
  // ── Existing endpoints ────────────────────────────────
  static const String register = "/api/Customer/AddCustomer";

  // ... your other existing endpoints

  // ── Main Backend (fixed base URL: http://15.235.51.177/TheOneAPI/api/) ──
  // These use a separate Dio instance — NOT the company server
  static const String getDeviceConfig = 'GetDeviceConfigV2';
  static const String checkDeviceActivate = 'CheckDeviceActivate';
  static const String deviceDeactivate = 'DeviceDeactivate';

  // ── Company Server (dynamic base URL from ActivationModel.server) ────────
  static const String login = 'api/Users/Login';

  static String bannerOne = "/api/Baner1";
  static String biggestDiscount = "/api/Product/GetProductsWithBiggestDiscount";
  static String bestSeller = "/api/Product/GetProductsWithBestSeller";
  static String newProduct = "/api/Product/GetNewProducts";
  static String subCategoryProducts = "/api/Product";

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
  static const String getSubCategory = '/api/Category/GetCategoryByParentId';
  static const String getProductsByCategory =
      '/api/Product/GetProductsByCategory';
  static const String searchProducts = '/api/Product/SearchProducts';
  static const String searchProductByBarcode =
      '/api/Product/SearchProductByBarcode';
  static const String getLastInvoiceByPattern =
      '/api/SalesInvoice/GetLastInvoiceByInvoiceID';
  static const String createSalesInvoice = '/api/SalesInvoice/Create';
  static const String editSalesInvoice = '/api/SalesInvoice/Edit';
  static const String getPayWays = '/api/PayWays';

  // Invoice Collection
  static const String getBranches = '/api/CompanyBranch/GetBranches';
  static const String getInvoicePatterns = '/api/InvoicePattern/GetByBranch';
  static const String getQuotePatterns = '/api/InvoicePattern/GetQuoteByBranch';
  static const String getCurrencies = '/api/Currency/GetCurrencies';

  static const String getReceiptsVouchersTypesByBranch =
      'api/VoucherSettings/GetReceiptsVouchersTypesByBranchID';

  static const String getCompanyBranchesByUser =
      'api/CompanyBranches/GetCompanyBranchesByUserID';

  static const String invoiceCollecting = 'api/Voucher/InvoiceCollecting';

  static const String updateInvoiceCollecting =
      'api/Voucher/UpdateInvoiceCollecting';
  static const String getReceiptsVouchersTypes =
      'api/VoucherSettings/GetReceiptsVouchersTypes';
}
