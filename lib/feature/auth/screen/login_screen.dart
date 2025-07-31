import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/controller/about%20_controlleer.dart';
import 'package:prettyrini/feature/auth/controller/login_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/route/route.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final LoginController loginController = Get.put(LoginController());

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              themeController.isDarkMode
                  ? ImagePath.loginDark
                  : ImagePath.loginLight,
              fit: BoxFit.fill,
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tilte_text_heading("LOGIN"),
                  SizedBox(height: 50.h),

                  // Email/Phone Field
                  Obx(() => CustomAuthField(
                        controller: loginController.emailController,
                        hintText: "Phone Number/Email",
                        borderColor: loginController.isEmailValid.value
                            ? Colors.grey
                            : Colors.red,
                        // onChanged: (value) {
                        //   loginController.validateEmail(value);
                        // },
                      )),
                  SizedBox(height: 10.h),

                  // Password Field
                  Obx(() => CustomAuthField(
                        controller: loginController.passwordController,
                        hintText: "Password",
                        //  isObscure: !loginController.isPasswordVisible.value,
                        borderColor: loginController.isPasswordValid.value
                            ? Colors.grey
                            : Colors.red,
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () {
                            loginController.togglePasswordVisibility();
                          },
                        ),
                        // onChanged: (value) {
                        //   loginController.validatePassword(value);
                        // },
                      )),
                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.resetPassScreen);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forget Password',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Login Button with Loading State
                  Obx(() => CustomButton(
                        onTap: loginController.isLoginLoading.value
                            ? null
                            : () async {
                                final success =
                                    await loginController.loginUser();
                                if (success) {
                                  Get.offAndToNamed(AppRoute.dashBoardScreen);
                                }
                              },
                        title: loginController.isLoginLoading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Logging in...",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Enter",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),

                  // Debug button for testing (remove in production)
                  if (Get.isRegistered<LoginController>())
                    SizedBox(height: 10.h),
                  if (Get.isRegistered<LoginController>())
                    TextButton(
                      onPressed: () {
                        loginController.fillTestCredentials();
                      },
                      child: Text(
                        "Fill Test Data",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.signUpScreen);
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
