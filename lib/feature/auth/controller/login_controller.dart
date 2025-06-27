import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/user_info.dart';

class LoginController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  var isLoginLoading = false.obs;
  var isLoginLoadingError = "".obs;
  var isPasswordVisible = false.obs;

  // Form validation
  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validation methods
  bool validateEmail(String email) {
    if (email.isEmpty) {
      isEmailValid.value = false;
      return false;
    }

    // Check if it's an email or phone number
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^[\+]?[1-9][\d]{0,15}$');

    isEmailValid.value =
        emailRegex.hasMatch(email) || phoneRegex.hasMatch(email);
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

  // Form validation
  bool validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    bool isValid = true;

    if (!validateEmail(email)) {
      isValid = false;
      Fluttertoast.showToast(
        msg: "Please enter a valid email or phone number",
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

    return isValid;
  }

  // Login method
  Future<bool> loginUser() async {
    if (!validateForm()) {
      return false;
    }

    try {
      log("loginUser started");
      isLoginLoading.value = true;
      isLoginLoadingError.value = '';

      // Prepare request body according to your JSON format
      final Map<String, dynamic> requestBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      log("Login Request Body: ${json.encode(requestBody)}");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.login, // Make sure this URL is defined as '/auth/login'
        json.encode(requestBody),
        is_auth: false,
      );

      log("loginUser response: $response");

      if (response['success'] == false) {
        AppSnackbar.show(
          message: response['message'] ?? 'Login failed',
          isSuccess: false,
        );
        return false;
      }

      if (response != null && response['success'] == true) {
        // Handle successful login
        final token = response['data']?['token'];
        if (token != null) {
          final userService = LocalService();
          userService.setToken(token);
        }

        // Store user data if available
        final userData = response['data']?['user'];
        if (userData != null) {
          final userService = LocalService();
          //  userService.setUserData(json.encode(userData));
        }

        Fluttertoast.showToast(
          msg: "Login successful",
          backgroundColor: Colors.green,
        );

        getProfileInfo();

        // Clear form after successful login
        clearForm();

        return true;
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Failed to login",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      isLoginLoadingError.value = e.toString();
      log("Login error: $e");

      Fluttertoast.showToast(
        msg: "Login failed. Please check your credentials and try again.",
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Clear form method
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    isEmailValid.value = true;
    isPasswordValid.value = true;
  }

  // Reset error states
  void resetErrorStates() {
    isLoginLoadingError.value = '';
    isEmailValid.value = true;
    isPasswordValid.value = true;
  }

  // Auto-fill for testing (remove in production)
  void fillTestCredentials() {
    emailController.text = "test@gmail.com";
    passwordController.text = "12345678";
  }

  Future<Map<String, dynamic>?> getProfileInfo() async {
    try {
      final Map<String, dynamic> requestBody = {};
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.userPofile,
        json.encode(requestBody),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        log("getProfileInfo ${response.toString()}");

        // final isCompleteProfile =
        //     response['data']['userProfile']['isCompleteProfile'];
        //    if (isCompleteProfile) {
        final userService = LocalService();

        //  final profileImage = response['data']['userProfile']['profileImage'];
        //  final role = response['data']['userProfile']['role'];
        final name = response['data']['userProfile']['fullName'];
        final id = response['data']['userProfile']['id'];
        //  final paymentStatus = response['data']['userProfile']['isPayment'];

        // Store data locally
        //  await userService.setImagePath(profileImage.toString());
        await userService.setName(name);
        //  await userService.setRole(role);
        await userService.setUserId(id);
        //  await userService.setPaymentStatus(paymentStatus);
        //   }

        return response; // Return full response
      } else {
        Fluttertoast.showToast(
          msg: "Failed To Get Your Profile Info.",
          backgroundColor: Colors.red,
        );
        return null;
      }
    } catch (e) {
      log("getProfileInfo error: $e");
      Fluttertoast.showToast(
        msg: "Failed To Get Your Profile Info.",
        backgroundColor: Colors.red,
      );
      return null;
    }
  }
}
