import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:get/get.dart';

class DataContoller extends GetxController {
  final carousalItems = <Map<String, dynamic>>[].obs;
  final categoryItems = <Map<String, dynamic>>[].obs;
  final salesCategoryItems = <Map<String, dynamic>>[].obs;
  final productsItems = <Map<String, dynamic>>[].obs;
  // final cartsItems = <String, dynamic>{}.obs;

  final cartsItems = {}.obs;
  final total = 0.0.obs;
  final subtotal = 0.0.obs;
  final discount = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCarousal();
    _fetchCategory();
    _fetchSalesCategory();
    _fetchProducts();
    _fetchCarts();
  }

  Future<void> _fetchCarousal() async {
    try {
      final carousal = await ApiService.fetchCarousal();
      carousalItems.assignAll(carousal); // Update the observable list
      isLoading.value = false; // Update loading state
    } catch (e) {
      print('Error fetching coupons: $e');
      isLoading.value = false;
    }
  }

  Future<void> _fetchCategory() async {
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

  Future<void> _fetchSalesCategory() async {
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

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      // print('Fetched Categories: $category');
      productsItems.assignAll(products);
      isLoading.value = false;
    } catch (e) {
      print('Error fetching sales Category: $e');
      isLoading.value = false;
    }
  }

  Future<void> _fetchCarts() async {
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

  // Future<void> _fetchCarts() async {
  //   try {
  //     final carts = await ApiService.fetchCarts();
  //     print('Fetched Carts in Controller: $carts');

  //     // Assign cart data to cartsItems
  //     cartsItems.value = carts['data']; // Assign the cart data

  //     // Fetch totals from the API response
  //     total.value = carts['total'].toDouble();
  //     subtotal.value = carts['subtotal'].toDouble();
  //     discount.value = carts['discount'].toDouble();
  //     deliveryFee.value = carts['deliveryfee'].toDouble();

  //     isLoading.value = false;
  //   } catch (e) {
  //     print('Error fetching Carts in controller: $e');
  //     isLoading.value = false;
  //   }
  // }
}
