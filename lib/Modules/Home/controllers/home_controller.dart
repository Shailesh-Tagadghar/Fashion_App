import 'dart:async';
import 'dart:convert';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  @override
  void onInit() {
    activePage.value = 0;
    pageController = PageController();
    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  //for navbar selection
  var selectedIndex = 0.obs;
  //counter button
  var quantity = 1.obs;
  //Wishlist Category
  var selectedCategoryIndex = (0).obs;

  //to change navbar index
  void onItemTapped(int index) {
    // print("Tapped index: $index");
    selectedIndex.value = index;
  }

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  //Home Page
  var dropdownValue = StringConstants.dropLoc1.obs;

  void setDropdownValue(String newValue) {
    dropdownValue.value = newValue;
  }

  //for banner value
  var currentPage = 0.obs;
  late PageController pageController;
  late Timer timer;

  // for home page timer
  var hours = 2.obs;
  var minutes = 0.obs;
  var seconds = 0.obs;
  // late Timer timer;

  //for get sales category
  var selectedsalesCategoryIndex = 0.obs;

  void setSelectedSalesCategory(int index) {
    selectedsalesCategoryIndex.value = index;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else if (minutes.value > 0) {
        minutes.value--;
        seconds.value = 59;
      } else if (hours.value > 0) {
        hours.value--;
        minutes.value = 59;
        seconds.value = 59;
      } else {
        timer.cancel(); // Stop the timer when it reaches zero
      }
    });
  }

  ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  //Wishlist page list view -- list
  final List<String> wishlistCategory = <String>[
    StringConstants.category1,
    StringConstants.category2,
    StringConstants.category3,
    StringConstants.category4,
    StringConstants.category5,
    StringConstants.category6,
  ];

  void setSelectedCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  RxBool isLoadingCategory = true.obs;
  RxString selectedCategoryId = "".obs;
  RxString selectedCategoryIdDashboard = "".obs;
  RxBool showAllImages = false.obs;

  void selectCategoryId(String category) {
    if (selectedCategoryId.value == category) {
      selectedCategoryId.value = "";
    } else {
      selectedCategoryId.value = category;
    }
  }

  void selectCategoryIdDashboard(String category) {
    if (selectedCategoryIdDashboard.value == category) {
      selectedCategoryIdDashboard.value = "";
    } else {
      selectedCategoryIdDashboard.value = category;
    }
  }

  RxMap<String, RxBool> likedProducts = <String, RxBool>{}.obs;

  void toggleLike(String productId, String categoryId) {
    // Initialize the like state if not already present
    if (!likedProducts.containsKey(productId)) {
      likedProducts[productId] = false.obs; // Default value is unliked (false)
    }

    // Toggle the like state
    likedProducts[productId]?.value =
        !(likedProducts[productId]?.value ?? false);

    // Perform the API call based on the new like state
    if (likedProducts[productId]?.value ?? false) {
      ApiService.likeProduct(
          productId, categoryId); // If true, like the product
    } else {
      unlikeProduct(productId, categoryId); // If false, unlike the product
    }
  }

  //wishlist unlike product
  Future<void> unlikeProduct(String productId, String categoryId) async {
    favouriteProducts
        .removeWhere((product) => product.productId?.sId == productId);
    // const token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5laGlsQGdtYWlsLmNvbSIsInVzZXJJZCI6IjY1NzZhYzcwMzhmN2ExY2M1N2I1MTE0NiIsImlhdCI6MTcwMjI3NjY0MX0.fmHtUARR-nHkar5UsibOFVcT5AgEDiWTSkq39sC6GQg';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');

    final data = {
      "product_id": productId,
      "category_id": categoryId,
    };

    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.addFavourite}'), // Same API URL
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
        body: json.encode(data),
      );

      print('Response: ${response.body}'); // Log the response body
      print('Status code: ${response.statusCode}'); // Log the status code
      if (response.statusCode == 200) {
        print("Product unliked successfully");
      } else {
        print("Failed to unlike product");
      }
    } catch (e) {
      print("Error unliking product: $e");
    }
  }

  List favouriteProducts = [].obs; // RxList to hold the favourite products

  RxBool isFetchingFavouriteProduct = true.obs;

  ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  //Product Details Screen Controller
  var activePage = 0.obs;

  void changeActivePage(int index) {
    activePage.value = index;
  }

  ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  // WishList Category List
  // RxList<String> categoryWishlist =
  //     ["All", "Jacket", "Shirt", "Pant", "T-Shirt", "Specs"].obs;

  // RxString selectedCategoryName = "".obs;
  // RxBool showAllImages = false.obs;

  // void selectCategory(String category) {
  //   if (selectedCategoryName.value == category) {
  //     selectedCategoryName.value = "";
  //   } else {
  //     selectedCategoryName.value = category;
  //   }
  // }

  ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  // Product Details SIZE Section

  var selectedProductColor = ''.obs;
  var selectedProductSize = ''.obs;

  void selectColor(String color) {
    selectedProductColor.value = color; // Update the selected color
  }

  void selectSize(String size) {
    selectedProductSize.value = size; // Update the selected size
  }

  var currentImage = ''.obs;
  var selectedProduct = ''.obs;

  void selectProduct(String productId) {
    selectedProduct.value = productId;
  }

  void updateImage(String imagePath) {
    currentImage.value = imagePath;
  }

  ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  //Cart Screen

  ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  //Coupon copy value
  var selectedCoupon = ''.obs;

  void setCoupon(String coupon) {
    selectedCoupon.value = coupon;
  }
}
