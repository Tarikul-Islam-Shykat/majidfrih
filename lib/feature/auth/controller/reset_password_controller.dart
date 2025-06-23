import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';

class ResetPasswordController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Text controller for email field
  final TextEditingController emailController = TextEditingController();

  // Observable variables for loading states
  var isResetLoading = false.obs;
  var isResetLoadingError = ''.obs;

  // Form validation
  bool validateForm() {
    if (emailController.text.trim().isEmpty) {
      AppSnackbar.show(
        message: 'Please enter your email',
        isSuccess: false,
      );
      return false;
    }

    // Basic email validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      AppSnackbar.show(
        message: 'Please enter a valid email address',
        isSuccess: false,
      );
      return false;
    }

    return true;
  }

  // Clear form
  void clearForm() {
    emailController.clear();
  }

  // Reset password function
  Future<bool> resetPassword() async {
    if (!validateForm()) {
      return false;
    }

    try {
      log("resetPassword started");
      isResetLoading.value = true;
      isResetLoadingError.value = '';

      // Prepare request body according to your JSON format
      final Map<String, dynamic> requestBody = {
        "email": emailController.text.trim(),
      };

      log("Reset Password Request Body: ${json.encode(requestBody)}");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.forgotPass, // Make sure this URL is defined as '/auth/forgot-password'
        json.encode(requestBody),
        is_auth: false,
      );

      log("resetPassword response: $response");

      if (response['success'] == false) {
        AppSnackbar.show(
          message: response['message'] ?? 'Reset password request failed',
          isSuccess: false,
        );
        return false;
      }

      if (response != null && response['success'] == true) {
        // Handle successful reset password request
        Fluttertoast.showToast(
          msg: response['message'] ?? "Password reset link sent to your email",
          backgroundColor: Colors.green,
        );

        AppSnackbar.show(
          message:
              response['message'] ?? 'Password reset link sent successfully',
          isSuccess: true,
        );

        // Clear form after successful request
        clearForm();

        return true;
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Failed to send reset password link",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      isResetLoadingError.value = e.toString();
      log("Reset password error: $e");

      Fluttertoast.showToast(
        msg: "Failed to send reset password link. Please try again.",
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isResetLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
