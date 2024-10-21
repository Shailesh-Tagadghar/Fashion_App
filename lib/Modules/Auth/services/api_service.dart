import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Register a user
  static Future<void> registerUser(
      Map<String, dynamic> registrationData) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');

    final storage = GetStorage();
    final fcmToken = storage.read('fcm_token');

    try {
      // log('Sending request to $url with data: $registrationData');

      var request = http.MultipartRequest('POST', url)
        ..fields['name'] = registrationData['name']
        ..fields['email'] = registrationData['email']
        ..fields['password'] = registrationData['password']
        ..fields['number'] = registrationData['number']
        ..fields['gender'] = registrationData['gender']
        ..fields['address'] = registrationData['address']
        ..fields['fcm_token'] = fcmToken ?? 'dummy_fcm_token'
        ..fields['login_type'] = registrationData['login_type'];

      if (registrationData['image'] != null) {
        var imageFile = File(registrationData['image']);
        var imageExtension = imageFile.path.split('.').last.toLowerCase();
        var mimeType;

        // Set MIME type based on file extension
        if (imageExtension == 'jpg' || imageExtension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (imageExtension == 'png') {
          mimeType = 'image/png';
        } else {
          throw Exception('Unsupported image format');
        }

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ));
      }

      var response = await request.send().timeout(
          const Duration(seconds: 30)); // Adding a timeout for network requests

      response.stream.transform(utf8.decoder).listen((value) {
        // log('Response body: $value');
        if (response.statusCode == 200) {
          final data = jsonDecode(value);
          log('User registered successfully');
          Get.snackbar("Success", "User registered successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          GetStorage().write('user_data', data);
          // storage.write('user_data', data);
          storage.write('token', data['token']); // Store token
          log('Data after registration : $data');
        } else {
          log('Server returned an error: ${response.statusCode}');
          // Get.snackbar(
          //     "Error", "Failed to register user: ${response.statusCode}",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          // throw Exception('Failed to register user');
        }
      });
    } catch (e) {
      log('Error during registration: $e');
      // Get.snackbar("Error", "Error during registration: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      // throw Exception('Failed to register user');
    }
  }

  //LOGIN USER
  static Future<void> loginUser(Map<String, dynamic> loginData) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');

    final fcmToken = GetStorage().read('fcm_token');

    try {
      // log('Sending login request to $url with data: $loginData');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': loginData['email'],
              'password': loginData['password'],
              'fcm_token': fcmToken ?? 'dummy_fcm_token',
              'login_type': loginData['login_type'],
            }),
          )
          .timeout(const Duration(
              seconds: 30)); // Adding a timeout for network requests

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar("Success", "User logged in successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        log('User logged in successfully');
        // Store the user information in GetStorage for persistence
        final storage = GetStorage();
        storage.write('user_data', data);
        storage.write('token', data['token']); // Store token
        storage.write('isLoggedIn', true);
        log('Data after Login : $data');
      } else {
        log('Server returned an error: ${response.statusCode}');
        // Get.snackbar("Error", "Failed to log in: ${response.statusCode}",
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.red,
        //     colorText: Colors.white);
        // throw Exception('Failed to log in');
      }
    } catch (e) {
      log('Error during login: $e');
      // Get.snackbar("Error", "Error during login: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      // throw Exception('Failed to log in');
    }
  }

  // Method to change password
  static Future<void> changePassword(
      Map<String, dynamic> data, String token) async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.forgetPassword}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add the token in the header
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data), // Encode the request body to JSON
      );

      if (response.statusCode == 200) {
        // Password change successful
        Get.snackbar("Success", "Password changed successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        log('Password changed successfully');
      } else {
        // Handle failure
        log('Failed to change password: ${response.body}');

        // Get.snackbar("Error", "Failed to change password: ${response.body}",
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.red,
        //     colorText: Colors.white);
        // throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      log('Error changing password: $e');
      // Get.snackbar("Error", "Error changing password: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
    }
  }

  // Fetch coupons
  static Future<List<Map<String, dynamic>>> fetchCoupons() async {
    const String url =
        '${ApiConstants.baseUrl}${ApiConstants.getCoupons}'; // Adjust endpoint as necessary

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        // log('Coupon DATA : $data');

        if (data is Map && data.containsKey('data')) {
          List<dynamic> coupons = data['data'];
          return coupons
              .map((coupon) => coupon as Map<String, dynamic>)
              .toList();
        } else {
          log('Unexpected response format');
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch coupons: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching coupons: $e');
      // Get.snackbar("Error", "Failed to fetch coupons: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to fetch coupons');
    }
  }

  //fetch Carousal
  static Future<List<Map<String, dynamic>>> fetchCarousal() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCarousal}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        // log('carousal DATA : $data');

        if (data is Map && data.containsKey('data')) {
          List<dynamic> carousal = data['data'];
          return carousal
              .map((carousal) => carousal as Map<String, dynamic>)
              .toList();
        } else {
          // Get.snackbar("Error", "Unexpected response format",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch coupons: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching coupons: $e');
      // Get.snackbar("Error", "Failed to fetch coupons: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to fetch coupons');
    }
  }

  //fetch Category
  static Future<List<Map<String, dynamic>>> fetchCategory() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCategory}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        // log('Category DATA : $data');

        if (data is Map && data.containsKey('data')) {
          List<dynamic> category = data['data'];
          return category
              .map((category) => category as Map<String, dynamic>)
              .toList();
        } else {
          // Get.snackbar("Error", "Unexpected response format",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch coupons: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching coupons: $e');
      // Get.snackbar("Error", "Failed to fetch coupons: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to fetch coupons');
    }
  }

  //fetch sales category
  static Future<List<Map<String, dynamic>>> fetchSalesCategory() async {
    const String url =
        '${ApiConstants.baseUrl}${ApiConstants.getSalesCategory}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        // log('Sales Category DATA : $data');

        if (data is Map && data.containsKey('data')) {
          List<dynamic> salesCategory = data['data'];
          return salesCategory
              .map((salesCategory) => salesCategory as Map<String, dynamic>)
              .toList();
        } else {
          // Get.snackbar("Error", "Unexpected response format",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Sales Category: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching coupons: $e');
      // Get.snackbar("Error", "Failed to fetch Sales Category: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to Sales Category');
    }
  }

  //fetch Products
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getProducts}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        // log('Product Data : $data');

        if (data is Map && data.containsKey('data')) {
          List<dynamic> product = data['data'];
          return product
              .map((product) => product as Map<String, dynamic>)
              .toList();
        } else {
          // Get.snackbar("Error", "Unexpected response format",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch product: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching coupons: $e');
      // Get.snackbar("Error", "Failed to fetch product: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to product');
    }
  }

  // add to cart
  Future<void> addToCart(String productId, String size) async {
    final token = GetStorage().read('token');
    log('Bearer Token : $token');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var body = json.encode({"product_id": productId, "size": size});

    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addcart}');

    try {
      var response = await http.post(url, headers: headers, body: body);
      log("Response Status in api service: ${response.statusCode}");
      log("Response Body in api service: ${response.body}");

      if (response.statusCode == 200) {
        log("Product added to cart successfully.");
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage =
            errorResponse['message'] ?? 'Something went wrong';
        log("Failed to add product to cart in api service: $errorMessage");
        log("Failed to add product to cart in api service: ${response.body}");
      }
    } catch (e) {
      log("Error adding product to cart in api service: $e");
    }
  }

  //remove cart from API
  static Future<void> removeProduct(String productId) async {
    final data = {
      "id": productId,
    };

    log('Sending data: $data');

    try {
      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.removeProduct}');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${GetStorage().read('token')}',
          "Content-Type": "application/json"
        },
        body: json.encode(data),
      );

      log('headers ${response.headers}');

      log('Response: ${response.body}'); // Log the response body
      log('Status code: ${response.statusCode}'); // Log the status code

      if (response.statusCode == 200) {
        log("Removed From Cart successfully");
      } else {
        log("Failed to Remove from cart");
      }
    } catch (e) {
      log("Error Removing From Cart: $e");
    }
    DataContoller().fetchCarts();
  }

  //fetch Carts
  static Future<Map<String, dynamic>> fetchCarts() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCart}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        log('Cart Data API Service : $data');

        if (data is Map && data.containsKey('data')) {
          Map<String, dynamic> carts = data['data'];
          return carts;
        } else {
          log('Unexpected response format');
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Carts API Service: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching Carts in API Service: $e');
      throw Exception('Failed to Carts');
    }
  }

  //fetch checkout
  static Future<Map<String, dynamic>> fetchCheckout() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCart}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        log('Cart Data API Service : $data');

        if (data is Map && data.containsKey('data')) {
          final Map<String, dynamic> data =
              jsonDecode(responseBody).cast<String, dynamic>();

          return data;
        } else {
          // Get.snackbar("Error", "Unexpected response format",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Carts API Service: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching Carts in API Service: $e');
      // Get.snackbar("Error", "Failed to fetch Carts: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to Carts');
    }
  }

  //verify Coupon
  static Future<Map<String, dynamic>> verifyCoupon(String couponCode,
      double subtotal, double discount, double deliveryFee) async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.verifyCoupon}';

    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode({
        "coupen_code": couponCode,
        "subtotal": subtotal,
        "discount": discount,
        "deliveryfee": deliveryFee,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        log('Coupon Verification Data : $data');

        if (data is Map && data.containsKey('data')) {
          log('Verify Coupon data : $data');
          return data['data'];
        } else {
          // Get.snackbar("Error", "Unexpected response format",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to verify coupon: ${response.statusCode}');
      }
    } catch (e) {
      log('Error verifying coupon: $e');
      // Get.snackbar("Error", "Failed to verify coupon: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white);
      throw Exception('Failed to verify coupon');
    }
  }

  //search result display
  static Future<List<dynamic>> fetchSearchResults(String searchText) async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.searchproduct}';
    final token = GetStorage().read('token');

    log('Bearer Token : $token');

    try {
      DataContoller().isLoading.value = true;
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode({"searchtext": searchText});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        if (jsonResponse != null && jsonResponse['data'] != null) {
          return jsonResponse['data'];
        } else {
          log('Unexpected response format: $jsonResponse');
          return [];
        }
      } else {
        log('API Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      log('Error fetching search results: $e');
      return [];
    } finally {
      DataContoller().isLoading.value =
          false; // Ensure loading stops after request
    }
  }

  // add and remove favourite

  //to add favourite
  static Future<void> addToFavorites(
      String productId, String categoryId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addFavorite}');
    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = json.encode({
      "product_id": productId,
      "category_id": categoryId,
    });

    DataContoller().isLoading.value = true;
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        log("Added to favorites in api service: $productId");
      } else {
        log("Failed to add to favorites in api service: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error adding to favorites in api service: $e");
    } finally {
      DataContoller().isLoading.value = false;
    }
  }

  //to remove favourite
  static Future<void> removeFromFavorite(
      String productId, String categoryId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addFavorite}');
    final token = GetStorage().read('token');
    log('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = json.encode({
      "product_id": productId,
      "category_id": categoryId,
    });

    DataContoller().isLoading.value = true;
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        log("Removed from favorites in api service: $productId");
      } else {
        log("Failed to remove from favorites in api service: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error remove from favorites in api service: $e");
    } finally {
      DataContoller().isLoading.value = false;
    }
  }

  // fetch favourite products
  static Future<List<String>> getFavoriteProducts() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getFavorite}');
    final token = GetStorage().read('token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data.containsKey('data')) {
          final List<dynamic> favoriteList = data['data'];

          return favoriteList
              .map((item) =>
                  item['product_id']['_id'] as String) // Access the product ID
              .toList(); // Ensure this is a List<String>
        } else {
          log('Unexpected response format: $data');
          return [];
        }
      } else {
        log('Failed to fetch favorites: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      log('Error fetching favorite products: $e');
      return [];
    }
  }

  // fetch product by category id
  static Future<dynamic> getCategoryProduct(String categoryId) async {
    final token = GetStorage().read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var body = json.encode({"category_id": categoryId});

    var response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getCategotyProducts}'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      return json.decode(response.body);
    } else {
      // Handle the error case
      log('Error to fetch product by category id in api service: ${response.reasonPhrase}');
      return null;
    }
  }

  // fetch product by sales_category id
  static Future<dynamic> getSalesCategoryProduct(String saleCategoryId) async {
    final token = GetStorage().read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var body = json.encode({"salecategory_id": saleCategoryId});

    var response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.salesCategoryProduct}'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Parse the JSON response
    } else {
      log('Error: ${response.reasonPhrase}');
      return null;
    }
  }

  // checkout product
  static Future<Map<String, dynamic>> checkout(String cartId) async {
    const String url =
        '${ApiConstants.baseUrl}${ApiConstants.checkout}'; // Adjust the URL as necessary

    final token = GetStorage().read('token');
    log('Bearer Token: $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode({
        "cartid": cartId,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        log('Checkout Response in api service: $data');

        // Check if the response format is correct
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        log('Error response in api service: ${response.reasonPhrase}');
        throw Exception(
            'Failed to checkout in api service: ${response.statusCode}');
      }
    } catch (e) {
      log('Error during checkout in api service: $e');
      throw Exception('Failed to checkout in api service');
    }
  }

  // add quantity
  Future<void> addQuantity(int quantity, String id) async {
    final data = {"qty": quantity, "id": id};

    log('Sending data in api service: $data');

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addQty}'),
        headers: {
          'Authorization': 'Bearer ${GetStorage().read('token')}',
          "Content-Type": "application/json"
        },
        body: json.encode(data),
      );

      log('Response in api service: ${response.body}');
      log('Status code in api service: ${response.statusCode}');

      if (response.statusCode == 200) {
        DataContoller().fetchCarts();
        log("Product Quantity Updated successfully in api service");
      } else {
        log("Failed to Add Quantity in api service");
      }
    } catch (e) {
      log("Error Adding Quantity to cart in api service: $e");
    }
  }
}
