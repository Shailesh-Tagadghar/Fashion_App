import 'dart:convert';
import 'dart:io';
import 'package:fashion/Modules/Home/Model/wishlist_model.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final HomeController homeController = Get.put(HomeController());
  // Register a user
  static Future<void> registerUser(
      Map<String, dynamic> registrationData) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');

    final storage = GetStorage();
    final fcmToken = storage.read('fcm_token');

    try {
      // print('Sending request to $url with data: $registrationData');

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
        // print('Response body: $value');
        if (response.statusCode == 200) {
          final data = jsonDecode(value);
          print('User registered successfully');
          Get.snackbar("Success", "User registered successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          GetStorage().write('user_data', data);
          // storage.write('user_data', data);
          storage.write('token', data['token']); // Store token
          print('Data after registration : $data');
        } else {
          print('Server returned an error: ${response.statusCode}');
          Get.snackbar(
              "Error", "Failed to register user: ${response.statusCode}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Failed to register user');
        }
      });
    } catch (e) {
      print('Error during registration: $e');
      Get.snackbar("Error", "Error during registration: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to register user');
    }
  }

  //LOGIN USER
  static Future<void> loginUser(Map<String, dynamic> loginData) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');

    final fcmToken = GetStorage().read('fcm_token');

    try {
      // print('Sending login request to $url with data: $loginData');

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
        print('User logged in successfully');
        // Store the user information in GetStorage for persistence
        final storage = GetStorage();
        storage.write('user_data', data);
        storage.write('token', data['token']); // Store token
        storage.write('isLoggedIn', true);
        print('Data after Login : $data');
      } else {
        print('Server returned an error: ${response.statusCode}');
        Get.snackbar("Error", "Failed to log in: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        throw Exception('Failed to log in');
      }
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar("Error", "Error during login: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to log in');
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
        print('Password changed successfully');
      } else {
        // Handle failure
        Get.snackbar("Error", "Failed to change password: ${response.body}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      Get.snackbar("Error", "Error changing password: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // Fetch coupons
  static Future<List<Map<String, dynamic>>> fetchCoupons() async {
    const String url =
        '${ApiConstants.baseUrl}${ApiConstants.getCoupons}'; // Adjust endpoint as necessary

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        // print('Coupon DATA : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          List<dynamic> coupons = data['data'];
          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          return coupons
              .map((coupon) => coupon as Map<String, dynamic>)
              .toList();
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch coupons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
      Get.snackbar("Error", "Failed to fetch coupons: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to fetch coupons');
    }
  }

  //fetch Carousal
  static Future<List<Map<String, dynamic>>> fetchCarousal() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCarousal}';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        // print('carousal DATA : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          List<dynamic> carousal = data['data'];
          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          return carousal
              .map((carousal) => carousal as Map<String, dynamic>)
              .toList();
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch coupons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
      Get.snackbar("Error", "Failed to fetch coupons: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to fetch coupons');
    }
  }

  //fetch Category
  static Future<List<Map<String, dynamic>>> fetchCategory() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCategory}';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Category Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        // print('Category DATA : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          List<dynamic> category = data['data'];
          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          return category
              .map((category) => category as Map<String, dynamic>)
              .toList();
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch coupons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
      Get.snackbar("Error", "Failed to fetch coupons: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to fetch coupons');
    }
  }

  //fetch sales category
  static Future<List<Map<String, dynamic>>> fetchSalesCategory() async {
    const String url =
        '${ApiConstants.baseUrl}${ApiConstants.getSalesCategory}';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Category Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        // print('Sales Category DATA : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          List<dynamic> salesCategory = data['data'];
          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          return salesCategory
              .map((salesCategory) => salesCategory as Map<String, dynamic>)
              .toList();
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Sales Category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
      Get.snackbar("Error", "Failed to fetch Sales Category: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to Sales Category');
    }
  }

  //fetch Products
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getProducts}';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Category Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        // print('Product Data : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          List<dynamic> product = data['data'];
          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          return product
              .map((product) => product as Map<String, dynamic>)
              .toList();
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception('Failed to fetch product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
      Get.snackbar("Error", "Failed to fetch product: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to product');
    }
  }

  // add to cart
  // Future<void> addToCart(String productId, String size) async {
  Future<void> addToCart(String cartData) async {
    // Retrieve the bearer token from GetStorage
    final token = GetStorage()
        .read('token'); // 'token' is the key where you store the Bearer token
    print('Bearer Token : $token');

    // Set up the headers with the retrieved token
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    // Create the request body with productId and size passed from the product detail screen
    // var body = json.encode({"product_id": productId, "size": size});
    var body = json.encode(cartData);

    // Send the POST request
    var request = http.Request(
        'POST', Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addcart}'));
    request.body = body;
    request.headers.addAll(headers);

    // Send the request and get the response
    http.StreamedResponse response = await request.send();

    // Check for response status and print the result
    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      print('add to cart data : $responseData');
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  //fetch Carts
  static Future<Map<String, dynamic>> fetchCarts() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCart}';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
      // 'Authorization':
      //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5laGlsQGdtYWlsLmNvbSIsInVzZXJJZCI6IjY1ODU0YWIwZjBmYWE3ZTJjZmY2NzYzMCIsImlhdCI6MTcwNDE3MDU1MH0.97dXImRYVRbZuLXeh1hDube2d4vSvIb_WZLtEB0Ju_4'
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Category Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        print('Cart Data API Service : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          Map<String, dynamic> carts = data['data'];

          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          return carts;
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Carts API Service: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Carts in API Service: $e');
      Get.snackbar("Error", "Failed to fetch Carts: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to Carts');
    }
  }

  //fetch checkout
  static Future<Map<String, dynamic>> fetchCheckout() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getCart}';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
    final headers = {
      'Authorization': 'Bearer $token',
      // 'Authorization':
      //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5laGlsQGdtYWlsLmNvbSIsInVzZXJJZCI6IjY1ODU0YWIwZjBmYWE3ZTJjZmY2NzYzMCIsImlhdCI6MTcwNDE3MDU1MH0.97dXImRYVRbZuLXeh1hDube2d4vSvIb_WZLtEB0Ju_4'
    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      // Send the request and await the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // print('Category Response body: $responseBody'); // Log the response body
        final data = jsonDecode(responseBody);
        print('Cart Data API Service : $data');

        // Check if data is a Map and contains the 'coupons' key
        if (data is Map && data.containsKey('data')) {
          // Map<String, dynamic> carts = data['data'];
          final Map<String, dynamic> data =
              jsonDecode(responseBody).cast<String, dynamic>();

          // Get.snackbar("Success", "Coupons fetched successfully",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
          // return carts;
          return data;
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Carts API Service: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Carts in API Service: $e');
      Get.snackbar("Error", "Failed to fetch Carts: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to Carts');
    }
  }

  //wishlist like product
  static Future<void> likeProduct(String productId, String categoryId) async {
    // const token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5laGlsQGdtYWlsLmNvbSIsInVzZXJJZCI6IjY1NzZhYzcwMzhmN2ExY2M1N2I1MTE0NiIsImlhdCI6MTcwMjI3NjY0MX0.fmHtUARR-nHkar5UsibOFVcT5AgEDiWTSkq39sC6GQg';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');

    final data = {
      "product_id": productId,
      "category_id": categoryId,
    };

    print('Sending data: $data'); // Debugging the data being sent

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addFavourite}'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: json.encode(data),
      );

      print('Response: ${response.body}'); // Log the response body
      print('Status code: ${response.statusCode}'); // Log the status code

      if (response.statusCode == 200) {
        print("Product liked successfully");
      } else {
        print("Failed to like product");
      }
    } catch (e) {
      print("Error liking product: $e");
    }
  }

//fetch fvt product
  Future<void> fetchFavouriteProduct() async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.getFavorite}';
    // final token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5laGlsQGdtYWlsLmNvbSIsInVzZXJJZCI6IjY1NzZhYzcwMzhmN2ExY2M1N2I1MTE0NiIsImlhdCI6MTcwMjI3NjY0MX0.fmHtUARR-nHkar5UsibOFVcT5AgEDiWTSkq39sC6GQg';

    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('Fetched Favorite Products: $data');

        if (data.containsKey('data')) {
          WishlistModel wishlistModel = WishlistModel.fromJson(data);
          homeController.favouriteProducts.assignAll(wishlistModel.data ?? []);
          print("Favourite Through Model = $homeController.favouriteProducts");
          homeController.isFetchingFavouriteProduct.value = false;
        } else {
          Get.snackbar("Error", "Unexpected response format",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch favorite products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorite products: $e');
      Get.snackbar("Error", "Failed to fetch favorite products: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw Exception('Failed to fetch favorite products');
    }
  }
}
