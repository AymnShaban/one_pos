import 'constants.dart';

class EndPoints {
  // test
  //   static const String baseUrl = "http://15.235.51.177/TheOneAPI";

  // mazyad
 // static const String baseUrl = "http://78.89.159.126:9393/TheOneAPIMazyad";

 // alharamayn
 static const String baseUrl = "http://78.89.159.126:9494/TheOneAPIElhrmeen";

  static String logIn(String customerPhone, String password) {
    return '/api/Customer/Login?CustomerPhone=$customerPhone&passWord=$password&Token=1111';
  }

  static const String register = "/api/Customer/AddCustomer";
  static String bannerOne = "/api/Baner1";
  static String biggestDiscount = "/api/Product/GetProductsWithBiggestDiscount";
  static String bestSeller = "/api/Product/GetProductsWithBestSeller";
  static String newProduct = "/api/Product/GetNewProducts";
  static const String getMainCategory = "/api/Category/GetMainCategory";
  static const String getSubCategory = "/api/Category/GetCategoryByParentId";

  static String subCategoryProducts = "/api/Product";

  static String productDetails = "/api/Product/GetProductById";
  static String addToBasket = "/api/Product/AddSalesBasket";
  static String deleteOneItemFromBasket = "/api/Product/DeleteSalesBasket";
  static String getCustomerBasket = "/api/Product/GetCustomerSalesBasket";
  static String addOrder = "/api/Order";
  static String getOrdersDetails = "/api/Order/GetOrderProductsByCustomerID";

  static String searchProducts = "/api/Product/SearchProducts";

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

  static String previousTrackingOrdersByPhone = "/api/Order/GetCurrentOrdersByCustomerPhone/$customerPhone";
  static String customerIsActive = "/api/Customers/CustomerIsActive?CustomerPhone=$customerPhone";

  static String updateProfileData = "/api/Customer/UpdateCustomer";
  static String profileData = "/api/Customers/GetCustomer?CustomerPhone=$customerPhone";

  static String previousOrdersItem({required int itemId}) =>
      "/api/Order/GetOrderProducts/$itemId?CustomerPhone=$customerPhone";

  static String couponsDiscountCode(var discountCode) =>
      "/api/Coupons/GetByCode/$discountCode?CustomerPhone=$customerPhone";

  static String bannerProductByIdImage({required int id}) =>
      "/api/BannerItems1?ImageName=$id&CustomerID=$customerPhone'";

  // Invoices
  static const String getInvoices = "/api/Invoices";
  static const String deleteInvoice = "/api/Invoices/Delete";
}
