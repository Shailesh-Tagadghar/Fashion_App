import 'dart:convert';
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
  Future<void> addToCart(String productId, String size) async {
    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');

    var headers = {
      // 'Authorization':
      //     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJlbW9AZ21haWwuY28iLCJ1c2VySWQiOiI2NmYyNjI0NWI3YjE1ZDk0YjVmMjg3OTUiLCJmY21Ub2tlbiI6ImNaZFBSTXRNUlMtRElHVXhoYlh4T0k6QVBBOTFiSHIzZTNueTZLdjQzX0FfWVdwUTRId0x1LTdLYXlaVk9IMldhcDV6cDFUYTJKOTVtMVNUaFNlZVpZelpFbGNVWlk3c0dZTHNmbXgxSkV6S1FCemxUaEZ2VjdoemtsWXZ0bjZveTdHR1JMN1hXUDV3Znkwc1lCWVM1N3lsNkQxc19nQlVERVoiLCJpYXQiOjE3MjgyNzIzNDl9.tB1sRk_I6bnm9PJhkWbo3VPuuyvYNyg7ksNcwRpFUHo',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var body = json.encode({"product_id": productId, "size": size});

    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addcart}');

    try {
      var response = await http.post(url, headers: headers, body: body);
      print("Response Status in api service: ${response.statusCode}");
      print("Response Body in api service: ${response.body}");

      if (response.statusCode == 200) {
        // Parse response or handle success
        print("Product added to cart successfully.");
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage =
            errorResponse['message'] ?? 'Something went wrong';
        print("Failed to add product to cart in api service: $errorMessage");
        print("Failed to add product to cart in api service: ${response.body}");
      }
    } catch (e) {
      print("Error adding product to cart in api service: $e");
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
      //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVuaXF1ZUBnbWFpbC5jb20iLCJ1c2VySWQiOiI2NzAzNmJmOWI3YjE1ZDk0YjVmMzA5ZTMiLCJmY21Ub2tlbiI6ImVKcTJ1Wk4yUjJPM1ZidlJuImVKcTJ1Wk4yUjJPM1ZidlJubHFfdW46QVBBOTFiRWFNNmxaTTBLY3EyaVFLMlpHZno2VkRHV2xQYW4tdGJ6T29DeTBEbkRGODFkWG83VWRGLWhzV1Z4UWVnYXFLT1RhanhGeEpoRFRGcXlsMEtLQzlvdHNic3ZNd0FTNjR2QlBTWXlzQ1RjODFUMTJvOWhEMW4LNjdqMUtmVUxGR1JFc3VnYk9TWXlzQ1RjODFUMTJvOWhEMW4iLCJpYXQiOjE3MjgyNzc0OTd9.Juc-r0I_iZmINPMOgA0KxeSo2pNhk6XuyqG9fLxikto'
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
          return carts;
        } else {
          print('Unexpected response format');
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Failed to fetch Carts API Service: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Carts in API Service: $e');
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

  //search result display
  static Future<List<dynamic>> fetchSearchResults(String searchText) async {
    const String url = '${ApiConstants.baseUrl}${ApiConstants.searchproduct}';
    final token = GetStorage().read('token');

    print('Bearer Token : $token');

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

        // Ensure the response contains the expected 'data' field
        if (jsonResponse != null && jsonResponse['data'] != null) {
          return jsonResponse['data']; // Returning only the data field
        } else {
          print('Unexpected response format: $jsonResponse');
          return [];
        }
      } else {
        print('API Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error fetching search results: $e');
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
    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
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
        print("Added to favorites in api service: $productId");
      } else {
        print(
            "Failed to add to favorites in api service: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error adding to favorites in api service: $e");
    } finally {
      DataContoller().isLoading.value = false;
    }
  }

  //to remove favourite
  static Future<void> removeFromFavorite(
      String productId, String categoryId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addFavorite}');
    final token = GetStorage()
        .read('token'); // Adjust if your token storage key is different
    print('Bearer Token : $token');
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
        print("Removed from favorites in api service: $productId");
      } else {
        print(
            "Failed to remove from favorites in api service: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error remove from favorites in api service: $e");
    } finally {
      DataContoller().isLoading.value = false;
    }
  }

  // fetch favourite products
  static Future<List<String>> getFavoriteProducts() async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getFavorite}'); // Adjust the endpoint as necessary
    final token = GetStorage()
        .read('token'); // Make sure the token is retrieved correctly
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response is a Map and contains the 'data' key
        if (data is Map && data.containsKey('data')) {
          final List<dynamic> favoriteList = data['data'];

          // Extract product IDs from the favoriteList
          return favoriteList
              .map((item) =>
                  item['product_id']['_id'] as String) // Access the product ID
              .toList(); // Ensure this is a List<String>
        } else {
          print('Unexpected response format: $data');
          return []; // Return an empty list if format is unexpected
        }
      } else {
        print('Failed to fetch favorites: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error fetching favorite products: $e');
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
      print(
          'Error to fetch product by category id in api service: ${response.reasonPhrase}');
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
      print('Error: ${response.reasonPhrase}');
      return null;
    }
  }
}
