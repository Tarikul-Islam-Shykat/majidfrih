import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:prettyrini/route/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../core/network_caller/endpoints.dart';
import '../../auth/screen/login_screen.dart';
import '../../auth/screen/profile_setup_screen.dart';

class SplashScreenController extends GetxController {
  var userImage = "".obs;
  var firstname = ''.obs;
  var lastName = ''.obs;
  void checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (kDebugMode) {
      print("token1$token");
    }
    if (token.isEmpty) {
      Get.offAll(() => LoginScreen());
    } else {
      try {
        // Make the GET request
        final response = await http.get(
          Uri.parse('${Urls.baseUrl}/auth/get-me'),
          headers: {"Authorization": token},
        );

        if (kDebugMode) {
          print(response.body);
        }
        if (response.statusCode == 201) {
          var data = jsonDecode(response.body);
          if (data['data']['isCompleted'] == true) {
            userImage.value = data['data']['profileImage'] ?? "";
            firstname.value = data['data']['firstName'];
            lastName.value = data['data']['lastName'];

            //Get.offAll(() => NavBarView());
          } else {
            Get.offAll(() => ProfileSetupScreen());
          }
        } else {
          if (kDebugMode) {
            print('Request failed with status: ${response.statusCode}');
          }
          //  Get.offAll(() => LoginScreen());
        }
      } catch (e) {
        // Handle any errors that occur during the request
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }

  void movingWelcomeScreen() async {
    Future.delayed(Duration(seconds: 2), () {
      Get.toNamed(AppRoute.welcomeScreen);
    });
  }

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    movingWelcomeScreen();
  }
}
