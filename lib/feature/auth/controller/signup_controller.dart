import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_snackbar.dart';
import 'package:prettyrini/core/const/country_list.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/user_info.dart';

class SignUpController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Observable states
  var isSignUpLoading = false.obs;
  var isSignUpLoadingError = "".obs;
  var selectedCountry = Rx<Map<String, String>>({
    "name": "Bangladesh",
    "code": "+880",
    "icon": "🇧🇩",
  });

  // Form validation
  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  var isPhoneValid = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with Bangladesh as default
    selectedCountry.value = countryList.firstWhere(
      (country) => country['name'] == 'Bangladesh',
      orElse: () => countryList.first,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Select country method
  void selectCountry(Map<String, String> country) {
    selectedCountry.value = country;
    update();
  }

  // Validation methods
  bool validateEmail(String email) {
    if (email.isEmpty) {
      isEmailValid.value = false;
      return false;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    isEmailValid.value = emailRegex.hasMatch(email);
    return isEmailValid.value;
  }

  bool validatePassword(String password) {
    if (password.isEmpty || password.length < 6) {
      isPasswordValid.value = false;
      return false;
    }
    isPasswordValid.value = true;
    return true;
  }

  bool validatePhone(String phone) {
    if (phone.isEmpty || phone.length < 10) {
      isPhoneValid.value = false;
      return false;
    }
    isPhoneValid.value = true;
    return true;
  }

  // Form validation
  bool validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    bool isValid = true;

    if (!validateEmail(email)) {
      isValid = false;
      Fluttertoast.showToast(
        msg: "Please enter a valid email",
        backgroundColor: Colors.red,
      );
    }

    if (!validatePassword(password)) {
      isValid = false;
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters",
        backgroundColor: Colors.red,
      );
    }

    if (!validatePhone(phone)) {
      isValid = false;
      Fluttertoast.showToast(
        msg: "Please enter a valid phone number",
        backgroundColor: Colors.red,
      );
    }

    return isValid;
  }

  // Get country code (remove + sign for API)
  String getCountryCode() {
    String code = selectedCountry.value['code'] ?? '+880';
    // Remove the + sign and any hyphens for API
    return code
        .replaceAll('+', '')
        .replaceAll('-', '')
        .split('')
        .take(3)
        .join();
  }

  // Format phone number with country code
  String getFormattedPhoneNumber() {
    final countryCode = selectedCountry.value['code'] ?? '+880';
    final phone = phoneController.text.trim();

    // If phone already starts with country code, return as is
    if (phone.startsWith(countryCode)) {
      return phone;
    }

    // Otherwise, prepend country code
    return '$countryCode$phone';
  }

  // Sign up method
  Future<bool> signUpUser() async {
    if (!validateForm()) {
      return false;
    }

    try {
      log("signUpUser started");
      isSignUpLoading.value = true;
      isSignUpLoadingError.value = '';

      // Prepare request body according to your JSON format
      final Map<String, dynamic> requestBody = {
        "phoneNumber": getFormattedPhoneNumber(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "countryCode": getCountryCode(),
        "countryName":
            selectedCountry.value['name']?.toLowerCase() ?? 'bangladesh',
      };

      log("Request Body: ${json.encode(requestBody)}");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.signUp, // Make sure this URL is defined
        json.encode(requestBody),
        is_auth: false,
      );

      log("signUpUser response: $response");

      if (response['success'] == false) {
        AppSnackbar.show(
          message: response['message'] ?? 'Sign up failed',
          isSuccess: false,
        );
        return false;
      }

      if (response != null && response['success'] == true) {
        // Handle successful registration
        final token = response['data']?['token'];
        if (token != null) {
          final userService = LocalService();
          userService.setToken(token);
        }

        Fluttertoast.showToast(
          msg: "Registration successful",
          backgroundColor: Colors.green,
        );

        // Clear form after successful registration
        clearForm();

        return true;
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Failed to register",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      isSignUpLoadingError.value = e.toString();
      log("SignUp error: $e");

      Fluttertoast.showToast(
        msg: "Registration failed. Please try again.",
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isSignUpLoading.value = false;
    }
  }

  // Clear form method
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    isEmailValid.value = true;
    isPasswordValid.value = true;
    isPhoneValid.value = true;
  }

  // Reset error states
  void resetErrorStates() {
    isSignUpLoadingError.value = '';
    isEmailValid.value = true;
    isPasswordValid.value = true;
    isPhoneValid.value = true;
  }
}
