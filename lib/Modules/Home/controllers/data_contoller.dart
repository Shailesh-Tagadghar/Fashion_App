import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:get/get.dart';

class DataContoller extends GetxController {
  final carousalItems = <Map<String, dynamic>>[].obs;
  final categoryItems = <Map<String, dynamic>>[].obs;
  final salesCategoryItems = <Map<String, dynamic>>[].obs;
  final productsItems = <Map<String, dynamic>>[].obs;
  final cartsItems = {}.obs;
  final checkoutItems = {}.obs;
  final total = 0.0.obs;
  final subtotal = 0.0.obs;
  final discount = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final isLoading = true.obs;

  final favoriteProducts = <String>[].obs; // Track favorite product IDs

  @override
  void onInit() {
    super.onInit();
    fetchCarousal();
    fetchCategory();
    fetchSalesCategory();
    fetchProducts();
    fetchCarts();
    fetchCheckout();
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
      favoriteProducts.assignAll(await ApiService.getFavoriteProducts());

      isLoading.value = false;
    } catch (e) {
      print('Error fetching sales Category: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCarts() async {
    try {
      final carts = await ApiService.fetchCarts();
      print('Fetched Carts in Controller: $carts');
      // cartsItems.assignAll(carts);
      cartsItems.value = carts;
      isLoading.value = false;
    } catch (e) {
      print('Error fetching Carts in controller: $e');
      isLoading.value = false;
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

// Fetch products by category ID
  Future<void> fetchCategoryProducts(String categoryId) async {
    var response = await ApiService.getCategoryProduct(categoryId);

    if (response != null) {
      print('Category Products: $response');
      // You can use the response to update UI state or process further
    } else {
      print('Failed to fetch products');
    }
  }

  // Fetch products by sales category ID
  Future<void> fetchSalesCategoryProducts(String saleCategoryId) async {
    var response = await ApiService.getSalesCategoryProduct(saleCategoryId);

    if (response != null) {
      print('Sales Category Products: $response');
      // You can use the response to update UI state or process further
    } else {
      print('Failed to fetch sales category products');
    }
  }
}
