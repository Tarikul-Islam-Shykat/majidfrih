// lib/feature/home/controller/enhanced_product_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/feature/home/model/product_model.dart';
import 'package:prettyrini/feature/home/service/currency%20_service.dart';

class EnhancedProductController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Observable variables
  var isLoading = false.obs;
  var isLoadingRates = false.obs;
  var nearbyProducts = <Product>[].obs;
  var exchangeRates = <String, double>{}.obs;

  // Current settings
  var selectedCountry = 'Bangladesh'.obs;
  var selectedLanguage = 'English'.obs;
  var selectedCurrency = 'BDT'.obs;

  // Available options
  final List<String> availableCountries = [
    'United States', // USD
    'Bangladesh', // BDT
    'United Kingdom', // GBP
    'France', // EUR
    'Germany', // EUR
    'Japan', // JPY
    'Canada', // CAD
    'Australia', // AUD
    'India', // INR
    'China', // CNY
    'Brazil', // BRL
    'Russia', // RUB
    'South Korea', // KRW
    'Mexico', // MXN
    'Turkey', // TRY
    'Saudi Arabia', // SAR
    'United Arab Emirates', // AED
    'Switzerland', // CHF
    'Norway', // NOK
    'Sweden', // SEK
  ];

  final List<String> availableLanguages = [
    'English',
    'French',
    'German',
    'Spanish',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Hindi',
    'Bengali',
    'Turkish',
    'Swedish',
    'Norwegian',
  ];

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    await loadExchangeRates();
    await loadProducts();
  }

  Future<void> loadExchangeRates() async {
    try {
      isLoadingRates.value = true;
      debugPrint('Loading exchange rates...');

      final rates = await CurrencyService.getExchangeRates();

      if (rates.isNotEmpty) {
        exchangeRates.value = rates;
        debugPrint('Exchange rates loaded: ${rates.keys.toList()}');
        debugPrint('Sample rates: BDT=${rates['BDT']}, EUR=${rates['EUR']}');

        // Test connection
        final isConnected = await CurrencyService.testConnection();
        debugPrint('Currency API connection test: $isConnected');

        // Trigger UI update for prices
        nearbyProducts.refresh();

        Fluttertoast.showToast(
          msg: "Exchange rates updated successfully",
          backgroundColor: Colors.green,
        );
      } else {
        debugPrint('No exchange rates received');
        Fluttertoast.showToast(
          msg: "Using fallback exchange rates",
          backgroundColor: Colors.orange,
        );
      }
    } catch (e) {
      debugPrint('Error loading exchange rates: $e');
      Fluttertoast.showToast(
        msg: "Failed to load exchange rates",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingRates.value = false;
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> requestBody = {};
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/product",
        json.encode(requestBody),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        final dataList = response['data'] as List;

        // Convert to Product objects
        List<Product> products = [];
        for (var item in dataList) {
          final product = Product.fromJson(item);
          products.add(product);
        }

        nearbyProducts.value = products;
        debugPrint('Loaded ${products.length} products');

        // Apply translations after loading products
        await translateProductNames();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to load products",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("Error loading products: $e");
      Fluttertoast.showToast(
        msg: "Failed to load products: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> translateProductNames() async {
    // if (selectedLanguage.value == 'English') return;

    // try {
    //   for (int i = 0; i < nearbyProducts.length; i++) {
    //     final product = nearbyProducts[i];

    //     // Try offline translation first
    //     String translatedName = TranslationService.getOfflineTranslation(
    //       product.name,
    //       selectedLanguage.value
    //     );

    //     // If no offline translation available, use online service
    //     if (translatedName == product.name && selectedLanguage.value != 'English') {
    //       translatedName = await TranslationService.translateText(
    //         product.name,
    //         selectedLanguage.value
    //       );
    //     }

    //     // Update product with translated name
    //     nearbyProducts[i] = product.copyWith(translatedName: translatedName);
    //   }

    //   nearbyProducts.refresh();
    // } catch (e) {
    //   debugPrint('Error translating product names: $e');
    // }
  }

  void changeCountry(String country) {
    selectedCountry.value = country;
    final newCurrency = CurrencyService.countryCurrencyMap[country] ?? 'USD';

    if (newCurrency != selectedCurrency.value) {
      selectedCurrency.value = newCurrency;
      debugPrint('Changed country to $country, currency to $newCurrency');

      // Force refresh of product prices
      nearbyProducts.refresh();

      // Show currency change feedback
      Fluttertoast.showToast(
        msg: "Currency changed to $newCurrency",
        backgroundColor: Colors.blue,
      );
    }
  }

  void changeLanguage(String language) async {
    if (language != selectedLanguage.value) {
      selectedLanguage.value = language;
      debugPrint('Changed language to $language');

      await translateProductNames();

      Fluttertoast.showToast(
        msg: "Language changed to $language",
        backgroundColor: Colors.blue,
      );
    }
  }

  double getConvertedPrice(Product product) {
    if (exchangeRates.isEmpty) {
      debugPrint('Warning: No exchange rates available for conversion');
      return product.price;
    }

    final convertedPrice = CurrencyService.convertPrice(
      product.price,
      product.originalCurrency,
      selectedCurrency.value,
      exchangeRates,
    );

    debugPrint(
        'Price conversion: ${product.price} ${product.originalCurrency} -> $convertedPrice ${selectedCurrency.value}');
    return convertedPrice;
  }

  String getFormattedPrice(Product product) {
    final convertedPrice = getConvertedPrice(product);
    return CurrencyService.formatCurrency(
        convertedPrice, selectedCurrency.value);
  }

  // String getTranslatedText(String text) {
  //   if (selectedLanguage.value == 'English') return text;

  //   // Try offline translation first
  //   String translated =
  //       TranslationService.getOfflineTranslation(text, selectedLanguage.value);
  //   return translated;
  // }

  void refreshData() async {
    debugPrint('Refreshing all data...');

    // Show loading state
    isLoading.value = true;

    try {
      // Reload exchange rates first
      await loadExchangeRates();

      // Then reload products
      await loadProducts();

      Fluttertoast.showToast(
        msg: "Data refreshed successfully",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      debugPrint('Error refreshing data: $e');
      Fluttertoast.showToast(
        msg: "Failed to refresh data",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Debug method to check current state
  void debugCurrentState() {
    debugPrint('=== Current Controller State ===');
    debugPrint('Selected Country: ${selectedCountry.value}');
    debugPrint('Selected Currency: ${selectedCurrency.value}');
    debugPrint('Selected Language: ${selectedLanguage.value}');
    debugPrint('Exchange Rates Count: ${exchangeRates.length}');
    debugPrint('Products Count: ${nearbyProducts.length}');
    debugPrint('Available Rates: ${exchangeRates.keys.toList()}');
    if (exchangeRates.isNotEmpty) {
      debugPrint('Sample Rate (BDT): ${exchangeRates['BDT']}');
      debugPrint('Sample Rate (EUR): ${exchangeRates['EUR']}');
    }
    debugPrint('================================');
  }
}
