import 'dart:developer';

import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:flutter/material.dart';
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
  RxInt quantity = 1.obs;
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
    // fetchCoupons();
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
      log(' fetching carousal: $carousalItems');
    } catch (e) {
      log('Error fetching carousal: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCategory() async {
    try {
      final category = await ApiService.fetchCategory();
      // log('Fetched Categories: $category');
      categoryItems.assignAll(category);
      isLoading.value = false;
    } catch (e) {
      log('Error fetching Category: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchSalesCategory() async {
    try {
      final salesCategory = await ApiService.fetchSalesCategory();
      // log('Fetched Categories: $category');
      salesCategoryItems.assignAll(salesCategory);
      isLoading.value = false;
    } catch (e) {
      log('Error fetching sales Category: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      // log('Fetched Categories: $category');
      productsItems.assignAll(products);
      filteredProductsItems
          .assignAll(productsItems); // Initially show all products

      favoriteProducts.assignAll(await ApiService.getFavoriteProducts());

      isLoading.value = false;
    } catch (e) {
      log('Error fetching products: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCarts() async {
    isLoading.value = true;
    try {
      final carts = await ApiService.fetchCarts();
      log('Fetched Carts in controller: $carts');
      cartsItems.assignAll(carts);
      update();
    } catch (e) {
      log('Error fetching Carts in controller: $e');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> fetchCheckout() async {
    try {
      final checkout = await ApiService.fetchCheckout();
      log('Fetched Checkout in Controller: $checkout');

      // Assign cart data to cartsItems
      checkoutItems.value = checkout['data']; // Assign the cart data

      // Fetch totals from the API response
      total.value = checkout['total'].toDouble();
      subtotal.value = checkout['subtotal'].toDouble();
      discount.value = checkout['discount'].toDouble();
      deliveryFee.value = checkout['deliveryfee'].toDouble();

      isLoading.value = false;
    } catch (e) {
      log('Error fetching Checkout in controller: $e');
      isLoading.value = false;
    }
  }

  // Future<void> fetchCoupons() async {
  //   try {
  //     final coupons = await ApiService.fetchCoupons();
  //     couponItems.assignAll(coupons); // Update the observable list
  //   } catch (e) {
  //     log('Error fetching coupons: $e');
  //   } finally {
  //     isLoading.value = false; // Stop loading regardless of success or failure
  //   }
  // }

  Future<void> verifyCoupon() async {
    final couponCode = selectedCoupon.value;
    // final cartSubtotal = subtotal.value;
    // final cartDiscount = discount.value;
    // final cartDeliveryFee = deliveryFee.value;

    try {
      final couponData = await ApiService.verifyCoupon(
          couponCode, subtotal.value, discount.value, deliveryFee.value);
      log('Verified Coupon popopopoppopo: ${couponData}');

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
      log('Error verifying coupon in controller: $e');
    }
  }

  Future<void> fetchFavoriteProducts() async {
    try {
      isLoading.value = true;
      favoriteProducts.assignAll(await ApiService.getFavoriteProducts());
      isLoading.value = false;
    } catch (e) {
      log('Error fetching favorite products: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryProducts(String categoryId) async {
    try {
      isLoading.value = true;
      selectedCategoryId.value = categoryId; // Set selected category ID
      var response = await ApiService.getCategoryProduct(categoryId);
      log('Fetched Category Products: $response'); // Log the response

      if (response != null) {
        if (response is Map<String, dynamic> && response.containsKey('data')) {
          // Assign the list of products from the 'data' key
          productsItems
              .assignAll(List<Map<String, dynamic>>.from(response['data']));
        } else {
          log('Expected a list of products in "data", but received something else');
        }
      } else {
        log('Failed to fetch products');
      }
      isLoading.value = false;
    } catch (e) {
      log('Error fetching Category Products: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchSalesCategoryProducts(String saleCategoryId) async {
    try {
      var response = await ApiService.getSalesCategoryProduct(saleCategoryId);
      if (response != null && response['status'] == 1) {
        log('Sales Category Products: $response');
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
        log('Failed to fetch sales category products');
      }
    } catch (e) {
      log('Error fetching sales category products: $e');
    }
  }

  Future<void> checkout() async {
    final cartId = cartsItems['_id']; // Extract cartId from cartsItems
    log('Checking out with cartId in controller: $cartId');

    try {
      final response =
          await ApiService.checkout(cartId); // Call the checkout method
      log('Checkout Response in controller: $response');

      // Show success message
      Get.snackbar("Success", "Checkout successful: ${response['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      removeSelectedCoupon(); // This is a method to clear the coupon value
      // Navigate to the checkout screen
      Get.offAllNamed(AppRoutes.checkoutScreen);
    } catch (e) {
      log('Error during checkout in controller: $e');
      Get.snackbar("Error", "Checkout failed: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void removeSelectedCoupon() {
    selectedCoupon.value = ''; // Reset coupon value

    log('Selected coupon has been removed.');
  }
}
