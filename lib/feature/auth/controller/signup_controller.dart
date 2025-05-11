import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';
import '../screen/profile_setup_screen.dart';

class SignInController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController conPasswordTEController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConPasswordVisible = false.obs;
  final isLoading = false.obs;

  void toggleConPasswordVisibility() {
    isConPasswordVisible.value = !isConPasswordVisible.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> handleSignUp() async {
    if (emailTEController.text.isEmpty || passwordTEController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    } else if (passwordTEController.text != conPasswordTEController.text) {
      Get.snackbar(
        "Error",
        "password not match",
      );
    } else {
      try {
        isLoading.value = true;
        final response = await http.post(
          Uri.parse(Urls.signUp),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailTEController.text,
            'password': passwordTEController.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['data']['token'];
          if (kDebugMode) {
            print(token);
          }
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("token", token);
          pref.setBool("isLogin", true);
          Get.offAll(() => ProfileSetupScreen());
          Get.snackbar(
            'Success',
            'User Registered successfully!',
            snackPosition: SnackPosition.TOP,
          );
        } else {
          final data = jsonDecode(response.body);
          Get.snackbar(
            'Error',
            '${data['message']}',
            snackPosition: SnackPosition.TOP,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Something went wrong',
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> handleGoogleSignUp() async {
    try {
      isLoading.value = true;
      // Implement Google Sign In logic here
      await Future.delayed(Duration(seconds: 2)); // Simulated API call
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google sign in failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
