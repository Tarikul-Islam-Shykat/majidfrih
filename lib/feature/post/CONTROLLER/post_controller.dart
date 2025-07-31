// lib/controllers/post_controller.dart

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/core/services_class/user_info.dart';
import 'package:prettyrini/feature/post/model/city_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';

class PostController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Form Controllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  // Observables
  var isLoading = false.obs;
  var isPostLoading = false.obs;
  var errorMessage = ''.obs;

  // Image handling
  var selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  // Country and Currency
  var selectedCountry = 'Bangladesh'.obs;
  var selectedCurrency = 'BDT'.obs;
  var currencySymbol = '৳'.obs;

  // Categories
  var categories = <CategoryModel>[].obs;
  var selectedCategory = Rxn<CategoryModel>();
  var isCategoryLoading = false.obs;

  // Country-Currency mapping
  static const Map<String, String> countryCurrencyMap = {
    'United States': 'USD',
    'Bangladesh': 'BDT',
    'United Kingdom': 'GBP',
    'France': 'EUR',
    'Germany': 'EUR',
    'Japan': 'JPY',
    'Canada': 'CAD',
    'Australia': 'AUD',
    'India': 'INR',
    'China': 'CNY',
    'Brazil': 'BRL',
    'Russia': 'RUB',
    'South Korea': 'KRW',
    'Mexico': 'MXN',
    'Turkey': 'TRY',
    'Saudi Arabia': 'SAR',
    'United Arab Emirates': 'AED',
    'Switzerland': 'CHF',
    'Norway': 'NOK',
    'Sweden': 'SEK',
  };

  // Currency symbols
  final Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'BDT': '৳',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'JPY': '¥',
    'INR': '₹',
    'CHF': 'CHF ',
    'CNY': '¥',
    'BRL': 'R\$',
    'RUB': '₽',
    'KRW': '₩',
    'MXN': '\$',
    'TRY': '₺',
    'SAR': 'SR',
    'AED': 'د.إ',
    'NOK': 'kr',
    'SEK': 'kr',
  };

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    updateCurrency();
  }

  @override
  @override
  void onClose() {
    productNameController.dispose();
    productPriceController.dispose();
    productDescriptionController.dispose();
    citySearchController.dispose(); // Add this line
    super.onClose();
  }

  // Update currency when country changes
  // void onCountryChanged(String country) {
  //   selectedCountry.value = country;
  //   updateCurrency();
  // }

  void onCountryChanged(String country) {
    selectedCountry.value = country;
    updateCurrency();

    // Clear previous city selection
    selectedCity.value = null;
    cities.clear();
    filteredCities.clear();
    citySearchController.clear();

    // Get country code and fetch cities
    String countryCode = getCountryCode(country);
    if (countryCode.isNotEmpty) {
      fetchCities(countryCode);
    }
  }

  void updateCurrency() {
    selectedCurrency.value = countryCurrencyMap[selectedCountry.value] ?? 'BDT';
    currencySymbol.value = currencySymbols[selectedCurrency.value] ?? '৳';
  }

  Future<void> fetchCitites(String countryCode) async {
    try {
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        '${Urls.baseUrl}/product/get-city-base-country?countryCode=$countryCode',
        null,
        is_auth: true,
      );

      log("Categories Response: $response");

      if (response['success'] == true) {
      } else {}
    } catch (e) {
    } finally {}
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      isCategoryLoading.value = true;
      errorMessage.value = '';

      log("Fetching categories...");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        '${Urls.baseUrl}/category',
        null,
        is_auth: true,
      );

      log("Categories Response: $response");

      if (response['success'] == true) {
        final List<dynamic> categoryData = response['data'];
        categories.value =
            categoryData.map((json) => CategoryModel.fromJson(json)).toList();

        log("Categories loaded: ${categories.length}");
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load categories';
      }
    } catch (e) {
      log("Error fetching categories: $e");
      errorMessage.value = 'Error loading categories: $e';
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // Post product with multipart request
  Future<bool> postProduct() async {
    if (!validateForm()) {
      return false;
    }

    if (selectedImage.value == null) {
      errorMessage.value = 'Please select a product image';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    try {
      log("postProduct started with multipart request");
      isPostLoading.value = true;
      errorMessage.value = '';

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? token = sh.getString("token");

      log("Token: $token");

      // Prepare data fields
      var dataFields = {
        "data": jsonEncode({
          "name": productNameController.text.trim(),
          "price": double.parse(productPriceController.text.trim()),
          "countryName": selectedCountry.value,
          "categoryId": selectedCategory.value?.id,
          "moneyCode": selectedCurrency.value,
          "cityName": selectedCity.value?.name ?? '',
          "description": productDescriptionController.text.trim(),
        }),
      };

      log("Post Product Data: ${dataFields['data']}");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/product"),
      );

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        //  'Authorization': "$token",
        'Authorization': token!
      });

      request.fields.addAll(dataFields);

      // Add the product image
      var imageBytes = await selectedImage.value!.readAsBytes();
      var imageFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'product_${selectedImage.value!.path.split('/').last}',
      );
      request.files.add(imageFile);

      log("Sending multipart request...");

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseJson = json.decode(responseString);

      log("Post Product Response: $responseJson");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        Get.snackbar(
          'Success',
          'Product posted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
        return true;
      } else {
        errorMessage.value =
            responseJson['message'] ?? 'Failed to post product';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      log("Error posting product: $e");
      errorMessage.value = 'Error posting product: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isPostLoading.value = false;
    }
  }

  bool validateForm() {
    if (productNameController.text.trim().isEmpty) {
      errorMessage.value = 'Product name is required';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    if (productPriceController.text.trim().isEmpty) {
      errorMessage.value = 'Product price is required';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    if (double.tryParse(productPriceController.text.trim()) == null) {
      errorMessage.value = 'Please enter a valid price';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    if (productDescriptionController.text.trim().isEmpty) {
      errorMessage.value = 'Product description is required';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    if (selectedCategory.value == null) {
      errorMessage.value = 'Please select a category';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    if (selectedCity.value == null) {
      errorMessage.value = 'Please select a city';
      Get.snackbar('Error', errorMessage.value);
      return false;
    }

    return true;
  }

  void clearForm() {
    productNameController.clear();
    productPriceController.clear();
    productDescriptionController.clear();
    citySearchController.clear();
    selectedCategory.value = null;
    selectedCity.value = null;
    selectedCountry.value = 'Bangladesh';
    selectedImage.value = null;
    cities.clear();
    filteredCities.clear();
    updateCurrency();
  }

  void onCategoryChanged(CategoryModel? category) {
    selectedCategory.value = category;
  }

  // Image selection methods
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      log("Error picking image from gallery: $e");
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      log("Error picking image from camera: $e");
      Get.snackbar(
        'Error',
        'Failed to take photo',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeSelectedImage() {
    selectedImage.value = null;
  }

  void showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Add these properties to your PostController class

// Cities
  var cities = <CityModel>[].obs;
  var selectedCity = Rxn<CityModel>();
  var isCityLoading = false.obs;
  var filteredCities = <CityModel>[].obs;
  var citySearchController = TextEditingController();

// Add this to onClose() method

// Add these methods to your PostController class

// Fetch cities based on country code
  Future<void> fetchCities(String countryCode) async {
    try {
      isCityLoading.value = true;

      log("Fetching cities for country code: $countryCode");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        '${Urls.baseUrl}/product/get-city-base-country?countryCode=$countryCode',
        null,
        is_auth: true,
      );

      log("Cities Response: $response");

      if (response['success'] == true) {
        final List<dynamic> cityData = response['data'];
        cities.value =
            cityData.map((json) => CityModel.fromJson(json)).toList();
        filteredCities.value = cities.value;

        log("Cities loaded: ${cities.length}");
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load cities';
      }
    } catch (e) {
      log("Error fetching cities: $e");
      errorMessage.value = 'Error loading cities: $e';
    } finally {
      isCityLoading.value = false;
    }
  }

// Filter cities based on search query
  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = cities.value;
    } else {
      filteredCities.value = cities.value
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

// Update onCountryChanged method

// Helper method to get country code from country name
  String getCountryCode(String countryName) {
    final Map<String, String> countryCodeMap = {
      'United States': 'US',
      'Bangladesh': 'BD',
      'United Kingdom': 'GB',
      'France': 'FR',
      'Germany': 'DE',
      'Japan': 'JP',
      'Canada': 'CA',
      'Australia': 'AU',
      'India': 'IN',
      'China': 'CN',
      'Brazil': 'BR',
      'Russia': 'RU',
      'South Korea': 'KR',
      'Mexico': 'MX',
      'Turkey': 'TR',
      'Saudi Arabia': 'SA',
      'United Arab Emirates': 'AE',
      'Switzerland': 'CH',
      'Norway': 'NO',
      'Sweden': 'SE',
    };

    return countryCodeMap[countryName] ?? '';
  }

// Update validation method

// Update clearForm method
}

// Category Model
class CategoryModel {
  final String id;
  final String title;
  final bool isNeedToPay;
  final double amount;
  final String moneyCode;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.title,
    required this.isNeedToPay,
    required this.amount,
    required this.moneyCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      isNeedToPay: json['isNeedToPay'] ?? false,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      moneyCode: json['moneyCode'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isNeedToPay': isNeedToPay,
      'amount': amount,
      'moneyCode': moneyCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => title;
}
