// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:prettyrini/core/network_caller/endpoints.dart';
// import 'package:prettyrini/core/network_caller/network_config.dart';

// class MyProductsController extends GetxController {
//   final NetworkConfig _networkConfig = NetworkConfig();

//   @override
//   void onClose() {
//     super.onClose();
//     getProductsData();
//   }

//   Future<void> getProductsData() async {
//     try {
//       final Map<String, dynamic> requestBody = {};
//       final response = await _networkConfig.ApiRequestHandler(
//         RequestMethod.PUT,
//         Urls.getMyProducts,
//         json.encode(requestBody),
//         is_auth: true,
//       );

//       log("getProfileInfo ${response.toString()}");

//       if (response != null && response['success'] == true) {
//         log("getData ${response.toString()}");
//         return response; // Return full response
//       } else {
//         Fluttertoast.showToast(
//           msg: "Failed To Get Your Profile Info.",
//           backgroundColor: Colors.red,
//         );
//         return null;
//       }
//     } catch (e) {
//       log("getProfileInfo error: $e");
//       Fluttertoast.showToast(
//         msg: "Failed To Get Your Profile Info.",
//         backgroundColor: Colors.red,
//       );
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/feature/get_my_products/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProductsController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Observable list of products
  RxList<Product> products = <Product>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProductsData();
  }

  Future<void> getProductsData() async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> requestBody = {};
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.getMyProducts,
        json.encode(requestBody),
        is_auth: true,
      );

      log("getProductsData ${response.toString()}");

      if (response != null && response['success'] == true) {
        final List<dynamic> productList = response['data'] ?? [];
        products.value =
            productList.map((json) => Product.fromJson(json)).toList();
        log("Products loaded: ${products.length}");
      } else {
        Fluttertoast.showToast(
          msg: "Failed to get your products.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      log("getProductsData error: $e");
      Fluttertoast.showToast(
        msg: "Failed to get your products.",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.DELETE,
        Urls.deleteMyProduct(productId),
        json.encode({}),
        is_auth: true,
      );

      log("deleteProduct ${response.toString()}");

      if (response != null && response['success'] == true) {
        // Remove product from local list
        products.removeWhere((product) => product.id == productId);
        Fluttertoast.showToast(
          msg: "Product deleted successfully.",
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to delete product.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      log("deleteProduct error: $e");
      Fluttertoast.showToast(
        msg: "Failed to delete product.",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(
      String productId,
      String name,
      double price,
      String description,
      String categoryId,
      String countryName,
      File? imageFile) async {
    try {
      isLoading.value = true;

      // Create multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(Urls.updateMyProduct(productId)),
      );

      // Add form data
      Map<String, dynamic> data = {
        "name": name,
        "price": price,
        "description": description,
        "categoryId": categoryId,
        "countryName": countryName,
      };

      request.fields['data'] = json.encode(data);

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? token = sh.getString("token");
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        //  'Authorization': "$token",
        'Authorization': token!
      });

      // Add image if provided
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      // Add authorization header (you'll need to get the token from your auth system)
      // request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(responseData);

      log("updateProduct ${jsonResponse.toString()}");

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        // Refresh the products list
        await getProductsData();
        Fluttertoast.showToast(
          msg: "Product updated successfully.",
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update product.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      log("updateProduct error: $e");
      Fluttertoast.showToast(
        msg: "Failed to update product.",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showDeleteConfirmation(String productId, String productName) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteProduct(productId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
