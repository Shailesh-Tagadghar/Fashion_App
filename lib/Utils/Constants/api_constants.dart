class ApiConstants {
  static const String baseUrl = 'http://fashionapp.idealake.com/api/';
  static const String imageBaseUrl = 'https://fashionapp.idealake.com/';
  static const String register = "user/signup";
  static const String login = "user/login";

  static const String editProfile = "user/editprofile";
  static const String forgetPassword = "user/forgotpassword";

  // Favourite Api endpoints
  static const String addFavourite = "favourite/addfavourite";

  // Cards Api endpoints
  static const String createCard = "cards/createcard";
  static const String updateCard = "cards/updatecard";

  // Products Api endpoints
  static const String getCategotyProducts = "product/getcategoryproduct";

  static const String salesCategoryProduct =
      "salescategory/getsalescategoryproduct";

  static const String getCategory = "category/getcategory";
  static const String getCarousal = "carousal/getcarousal";
  static const String getSalesCategory = "salescategory/getsalescategory";
  static const String getProducts = "product/getproducts";

//Cart Api endpoints
  static const String addcart = "cart/addcart";

  //Get Cart
  static const String getCart = "cart/getcart";

  //Remove Product
  static const String removeProduct = "cart/removeproduct";

  //Get Coupons
  static const String getCoupons = "coupen/getcoupens";

  //Add Quantity
  static const String addQty = "cart/addqty";

  //update profile
  static const String updateProfile = "user/editprofile";

  //Checkout
  static const String checkout = "order/checkout";

  //Add to Favorite Api endpoints
  static const String addFavorite = "favourite/addfavourite";

  //Get Favorite Api endpoints
  static const String getFavorite = "favourite/getfavourite";

  //verify coupon
  static const String verifyCoupon = "cart/verifycoupen";

  //create aadress
  static const String createAddress = "/address/createaddress";

  //get address
  static const String getAddress = "address/getaddress";

  //update address
  static const String updateAddress = "address/updateaddress";

//change password
  static const String changePassword = "user/forgotpassword";

//get shipping mode
  static const String getShippingMode = "shippingmode/getshippingmode";
}
