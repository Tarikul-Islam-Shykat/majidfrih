import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/user_info.dart';

class ResetPasswordController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Text controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Loading states
  var isResetLoading = false.obs;
  var resetLoadingError = ''.obs;

  // Password visibility
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Email from previous screen (OTP verification)
  var email = ''.obs;

  // Form validation
  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments if passed from previous screen
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
    }

    // Listen to text changes for form validation
    newPasswordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validate form in real-time
  void validateForm() {
    isFormValid.value = newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        newPasswordController.text.length >= 6 &&
        newPasswordController.text == confirmPasswordController.text;
  }

  // Validate reset password form
  bool validateResetPasswordForm() {
    if (email.value.isEmpty) {
      AppSnackbar.show(
        message: 'Email is required',
        isSuccess: false,
      );
      return false;
    }

    if (newPasswordController.text.isEmpty) {
      AppSnackbar.show(
        message: 'New password is required',
        isSuccess: false,
      );
      return false;
    }

    if (newPasswordController.text.length < 6) {
      AppSnackbar.show(
        message: 'Password must be at least 6 characters long',
        isSuccess: false,
      );
      return false;
    }

    if (confirmPasswordController.text.isEmpty) {
      AppSnackbar.show(
        message: 'Please confirm your password',
        isSuccess: false,
      );
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      AppSnackbar.show(
        message: 'Passwords do not match',
        isSuccess: false,
      );
      return false;
    }

    // Additional password strength validation
    if (!isPasswordStrong(newPasswordController.text)) {
      AppSnackbar.show(
        message:
            'Password should contain at least one uppercase letter, one lowercase letter, and one number',
        isSuccess: false,
      );
      return false;
    }

    return true;
  }

  // Check password strength
  bool isPasswordStrong(String password) {
    // Basic password strength check
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }

  // Reset password API call
  Future<bool> resetPassword() async {
    if (!validateResetPasswordForm()) {
      return false;
    }

    try {
      log("resetPassword started");
      isResetLoading.value = true;
      resetLoadingError.value = '';

      // Prepare request body according to your JSON format
      final Map<String, dynamic> requestBody = {
        "email": email.value,
        "password": newPasswordController.text.trim(),
      };

      log("Reset Password Request Body: ${json.encode(requestBody)}");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.resetPassword, // Make sure this URL is defined as '/auth/reset-password'
        json.encode(requestBody),
        is_auth: false,
      );

      log("resetPassword response: $response");

      if (response['success'] == false) {
        AppSnackbar.show(
          message: response['message'] ?? 'Password reset failed',
          isSuccess: false,
        );
        return false;
      }

      if (response != null && response['success'] == true) {
        // Handle successful password reset
        final token = response['data']?['token'];
        if (token != null) {
          final userService = LocalService();
          userService.setToken(token);
        }

        // Store user data if available
        final userData = response['data']?['user'];
        if (userData != null) {
          final userService = LocalService();
          // userService.setUserData(json.encode(userData));
        }

        Fluttertoast.showToast(
          msg: "Password reset successfully",
          backgroundColor: Colors.green,
        );

        // Clear form after successful reset
        clearForm();

        // Navigate to login screen or dashboard
        // Get.offAllNamed(AppRoute.loginScreen);

        return true;
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Failed to reset password",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      resetLoadingError.value = e.toString();
      log("Reset password error: $e");

      Fluttertoast.showToast(
        msg: "Password reset failed. Please try again.",
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isResetLoading.value = false;
    }
  }

  // Clear form fields
  void clearForm() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    isNewPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
    isFormValid.value = false;
  }

  // Set email (if needed to be called from outside)
  void setEmail(String emailValue) {
    email.value = emailValue;
  }

  // Get password strength indicator
  String getPasswordStrengthText() {
    final password = newPasswordController.text;
    if (password.isEmpty) return '';

    if (password.length < 6) return 'Too short';

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strength = 0;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecialChar) strength++;

    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  // Get password strength color
  Color getPasswordStrengthColor() {
    final strengthText = getPasswordStrengthText();
    switch (strengthText) {
      case 'Weak':
        return Colors.red;
      case 'Fair':
        return Colors.orange;
      case 'Good':
        return Colors.blue;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
