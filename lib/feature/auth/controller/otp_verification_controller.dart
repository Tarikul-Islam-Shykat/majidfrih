import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/user_info.dart';

class OtpController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  // Controllers for OTP input fields
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // Focus nodes for OTP input fields
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // Loading states
  var isVerifyLoading = false.obs;
  var isResendLoading = false.obs;
  var verifyLoadingError = ''.obs;
  var resendLoadingError = ''.obs;

  // Email from previous screen
  var email = ''.obs;

  // OTP validation
  var isOtpComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments if passed from previous screen
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
    }
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }

  // Get complete OTP string
  String get otpString {
    return otpControllers.map((controller) => controller.text).join();
  }

  // Check if OTP is complete
  void checkOtpComplete() {
    isOtpComplete.value = otpString.length == 4 &&
        otpString.split('').every((digit) => digit.isNotEmpty);
  }

  // Handle OTP input change
  void onOtpChanged(String value, int index) {
    // Auto focus to next field when this field is filled
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    }

    // Auto focus to previous field when this field is empty
    if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }

    checkOtpComplete();
  }

  // Validate OTP form
  bool validateOtpForm() {
    if (email.value.isEmpty) {
      AppSnackbar.show(
        message: 'Email is required',
        isSuccess: false,
      );
      return false;
    }

    if (otpString.length != 4) {
      AppSnackbar.show(
        message: 'Please enter complete 4-digit OTP',
        isSuccess: false,
      );
      return false;
    }

    if (!otpString
        .split('')
        .every((digit) => RegExp(r'^\d$').hasMatch(digit))) {
      AppSnackbar.show(
        message: 'OTP should contain only digits',
        isSuccess: false,
      );
      return false;
    }

    return true;
  }

  // Verify OTP
  Future<bool> verifyOtp() async {
    if (!validateOtpForm()) {
      return false;
    }

    try {
      log("verifyOtp started");
      isVerifyLoading.value = true;
      verifyLoadingError.value = '';

      // Prepare request body according to your JSON format
      final Map<String, dynamic> requestBody = {
        "email": email.value,
        "otp": int.parse(otpString),
      };

      log("OTP Verification Request Body: ${json.encode(requestBody)}");

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.verifyOTP, // Make sure this URL is defined as '/auth/verify-otp'
        json.encode(requestBody),
        is_auth: false,
      );

      log("verifyOtp response: $response");

      if (response['success'] == false) {
        AppSnackbar.show(
          message: response['message'] ?? 'OTP verification failed',
          isSuccess: false,
        );
        return false;
      }

      if (response != null && response['success'] == true) {
        // Handle successful OTP verification
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
          msg: "OTP verified successfully",
          backgroundColor: Colors.green,
        );

        // Clear OTP fields after successful verification
        clearOtpFields();

        // Navigate to next screen (e.g., dashboard or home)
        // Get.offAllNamed(AppRoute.dashboardScreen);

        return true;
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Failed to verify OTP",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      verifyLoadingError.value = e.toString();
      log("OTP verification error: $e");

      Fluttertoast.showToast(
        msg: "OTP verification failed. Please try again.",
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isVerifyLoading.value = false;
    }
  }

  // Resend OTP
  // Future<bool> resendOtp() async {
  //   if (email.value.isEmpty) {
  //     AppSnackbar.show(
  //       message: 'Email is required to resend OTP',
  //       isSuccess: false,
  //     );
  //     return false;
  //   }

  //   try {
  //     log("resendOtp started");
  //     isResendLoading.value = true;
  //     resendLoadingError.value = '';

  //     // Prepare request body for resend OTP
  //     final Map<String, dynamic> requestBody = {
  //       "email": email.value,
  //     };

  //     log("Resend OTP Request Body: ${json.encode(requestBody)}");

  //     final response = await _networkConfig.ApiRequestHandler(
  //       RequestMethod.POST,
  //       Urls.resendOtp, // Make sure this URL is defined as '/auth/resend-otp'
  //       json.encode(requestBody),
  //       is_auth: false,
  //     );

  //     log("resendOtp response: $response");

  //     if (response['success'] == false) {
  //       AppSnackbar.show(
  //         message: response['message'] ?? 'Failed to resend OTP',
  //         isSuccess: false,
  //       );
  //       return false;
  //     }

  //     if (response != null && response['success'] == true) {
  //       Fluttertoast.showToast(
  //         msg: "OTP sent successfully",
  //         backgroundColor: Colors.green,
  //       );

  //       // Clear existing OTP fields
  //       clearOtpFields();

  //       return true;
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: response['message'] ?? "Failed to resend OTP",
  //         backgroundColor: Colors.red,
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     resendLoadingError.value = e.toString();
  //     log("Resend OTP error: $e");

  //     Fluttertoast.showToast(
  //       msg: "Failed to resend OTP. Please try again.",
  //       backgroundColor: Colors.red,
  //     );
  //     return false;
  //   } finally {
  //     isResendLoading.value = false;
  //   }
  // }

  // Clear OTP fields
  void clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    isOtpComplete.value = false;
    // Focus on first field
    if (focusNodes.isNotEmpty) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[0]);
    }
  }

  // Set email (if needed to be called from outside)
  void setEmail(String emailValue) {
    email.value = emailValue;
  }
}
