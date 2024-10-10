import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:get/get.dart';

class DataContoller extends GetxController {
  final carousalItems = <Map<String, dynamic>>[].obs;
  final categoryItems = <Map<String, dynamic>>[].obs;
  final salesCategoryItems = <Map<String, dynamic>>[].obs;
  final productsItems = <Map<String, dynamic>>[].obs;
  final filteredProductsItems =
      <Map<String, dynamic>>[].obs; // Filtered Products
  var couponItems = <Map<String, dynamic>>[].obs;
  final cartsItems = {}.obs;
  final checkoutItems = {}.obs;
  final total = 0.0.obs;
  final subtotal = 0.0.obs;
  final discount = 0.0.obs;
  final discountApplied = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final favoriteProducts = <String>[].obs;
  final selectedCategoryId = ''.obs;
  final isAppliedDone = false.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCarousal();
    fetchCategory();
    fetchSalesCategory();
    fetchProducts();
    fetchCarts();
    fetchCheckout();
    fetchCoupons();
  }

  //Coupon copy value
  var selectedCoupon = ''.obs;

  void setCoupon(String coupon) {
    selectedCoupon.value = coupon;
  }

  Future<void> fetchCarousal() async {
    try {
      final carousal = await ApiService.fetchCarousal();
      carousalItems.assignAll(carousal); // Update the observable list
      isLoading.value = false; // Update loading state
    } catch (e) {
      print('Error fetching coupons: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCategory() async {
    try {
      final category = await ApiService.fetchCategory();
      // print('Fetched Categories: $category');
      categoryItems.assignAll(category);
      isLoading.value = false;
    } catch (e) {
      print('Error fetching Category: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchSalesCategory() async {
    try {
      final salesCategory = await ApiService.fetchSalesCategory();
      // print('Fetched Categories: $category');
      salesCategoryItems.assignAll(salesCategory);
      isLoading.value = false;
    } catch (e) {
      print('Error fetching sales Category: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      // print('Fetched Categories: $category');
      productsItems.assignAll(products);
      filteredProductsItems
          .assignAll(productsItems); // Initially show all products

      favoriteProducts.assignAll(await ApiService.getFavoriteProducts());

      isLoading.value = false;
    } catch (e) {
      print('Error fetching products: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCarts() async {
    isLoading.value = true;
    try {
      final carts = await ApiService.fetchCarts();
      print('Fetched Carts in controller: $carts');
      cartsItems.assignAll(carts);
      update();
    } catch (e) {
      print('Error fetching Carts in controller: $e');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> fetchCheckout() async {
    try {
      final checkout = await ApiService.fetchCheckout();
      print('Fetched Checkout in Controller: $checkout');

      // Assign cart data to cartsItems
      checkoutItems.value = checkout['data']; // Assign the cart data

      // Fetch totals from the API response
      total.value = checkout['total'].toDouble();
      subtotal.value = checkout['subtotal'].toDouble();
      discount.value = checkout['discount'].toDouble();
      deliveryFee.value = checkout['deliveryfee'].toDouble();

      isLoading.value = false;
    } catch (e) {
      print('Error fetching Checkout in controller: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCoupons() async {
    try {
      final coupons = await ApiService.fetchCoupons();
      couponItems.assignAll(coupons); // Update the observable list
    } catch (e) {
      print('Error fetching coupons: $e');
    } finally {
      isLoading.value = false; // Stop loading regardless of success or failure
    }
  }

  Future<void> verifyCoupon() async {
    final couponCode = selectedCoupon.value;
    // final cartSubtotal = subtotal.value;
    // final cartDiscount = discount.value;
    // final cartDeliveryFee = deliveryFee.value;

    try {
      final couponData = await ApiService.verifyCoupon(
          couponCode, subtotal.value, discount.value, deliveryFee.value);
      print('Verified Coupon popopopoppopo: ${couponData}');

      // Update checkout items and totals with coupon data
      // checkoutItems.value = couponData;
      subtotal.value = couponData['subtotal'].toDouble();
      discount.value = couponData['discount'].toDouble();
      deliveryFee.value = couponData['deliveryfee'].toDouble();
      total.value = couponData['total'].toDouble();

      isAppliedDone.value = true;

      subtotal.refresh();
      discount.refresh();
      deliveryFee.refresh();
      total.refresh();

      // update();
    } catch (e) {
      print('Error verifying coupon in controller: $e');
    }
  }

  Future<void> fetchFavoriteProducts() async {
    try {
      isLoading.value = true;
      favoriteProducts.assignAll(await ApiService.getFavoriteProducts());
      isLoading.value = false;
    } catch (e) {
      print('Error fetching favorite products: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryProducts(String categoryId) async {
    try {
      isLoading.value = true;
      selectedCategoryId.value = categoryId; // Set selected category ID
      var response = await ApiService.getCategoryProduct(categoryId);
      print('Fetched Category Products: $response'); // Log the response

      if (response != null) {
        if (response is Map<String, dynamic> && response.containsKey('data')) {
          // Assign the list of products from the 'data' key
          productsItems
              .assignAll(List<Map<String, dynamic>>.from(response['data']));
        } else {
          print(
              'Expected a list of products in "data", but received something else');
        }
      } else {
        print('Failed to fetch products');
      }
      isLoading.value = false;
    } catch (e) {
      print('Error fetching Category Products: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchSalesCategoryProducts(String saleCategoryId) async {
    try {
      var response = await ApiService.getSalesCategoryProduct(saleCategoryId);
      if (response != null && response['status'] == 1) {
        print('Sales Category Products: $response');
        var productsList = response['data'] as List; // Get the list of products
        if (productsList.isNotEmpty) {
          // Update the productsItems
          productsItems.assignAll(
            productsList
                .map((product) => product as Map<String, dynamic>)
                .toList(),
          );

          // Update filtered products
          filteredProductsItems.assignAll(
            productsList
                .map((product) => product as Map<String, dynamic>)
                .toList(),
          );
        } else {
          // If there are no products, you can choose to clear the filtered list or handle accordingly
          filteredProductsItems.clear();
        }
      } else {
        print('Failed to fetch sales category products');
      }
    } catch (e) {
      print('Error fetching sales category products: $e');
    }
  }
}
