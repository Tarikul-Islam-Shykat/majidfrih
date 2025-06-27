import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/country_list.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/controller/signup_controller.dart';
import 'package:prettyrini/feature/auth/screen/forget_pasword_screen.dart';
import 'package:prettyrini/feature/auth/screen/reset_password.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/feature/profile_setUp/ui/profile_setup_ui.dart';
import 'package:prettyrini/route/route.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final SignUpController signUpController = Get.put(SignUpController());

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
                  tilte_text_heading("SIGN UP"),
                  SizedBox(height: 50.h),

                  // Email Field
                  Obx(() => CustomAuthField(
                        controller: signUpController.emailController,
                        hintText: "Email",
                        borderColor: signUpController.isEmailValid.value
                            ? Colors.grey
                            : Colors.red,
                        // onChanged: (value) {
                        //   signUpController.validateEmail(value);
                        // },
                      )),
                  SizedBox(height: 10.h),

                  // Password Field
                  Obx(() => CustomAuthField(
                        controller: signUpController.passwordController,
                        hintText: "Password",
                        // isObscure: true,
                        borderColor: signUpController.isPasswordValid.value
                            ? Colors.grey
                            : Colors.red,
                        // onChanged: (value) {
                        //   signUpController.validatePassword(value);
                        // },
                      )),
                  SizedBox(height: 10.h),

                  // Phone Number Field with Country Selector
                  Obx(() => Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: signUpController.isPhoneValid.value
                                ? Colors.grey
                                : Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: Row(
                          children: [
                            // Country selector
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => ListView.builder(
                                    itemCount: countryList.length,
                                    itemBuilder: (_, index) {
                                      final country = countryList[index];
                                      return ListTile(
                                        leading: Text(
                                          country['icon'] ?? '',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        title: Text(country['name'] ?? ''),
                                        subtitle: Text(
                                          country['code'] ?? '',
                                        ),
                                        onTap: () {
                                          signUpController
                                              .selectCountry(country);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      signUpController
                                              .selectedCountry.value['icon'] ??
                                          '',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16.sp, color: Colors.white),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      signUpController
                                              .selectedCountry.value['code'] ??
                                          '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        color: themeController.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const VerticalDivider(width: 1, color: Colors.grey),

                            // Phone number input
                            Expanded(
                              child: TextFormField(
                                controller: signUpController.phoneController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Phone number",
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 16.sp, color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  signUpController.validatePhone(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          // Navigate to forgot password
                          Get.to(ResetPassword());
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forget Password',
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Sign Up Button with Loading State
                  Obx(() => CustomButton(
                        onTap: signUpController.isSignUpLoading.value
                            ? null
                            : () async {
                                final success =
                                    await signUpController.signUpUser();
                                if (success) {
                                  String email =
                                      signUpController.emailController.text;
                                  String phoneNumber =
                                      signUpController.phoneController.text;
                                  log(email);
                                  Get.to(ProfileEditScreen(), arguments: {
                                    'email': email,
                                    'number': phoneNumber,
                                  });
                                }
                              },
                        title: signUpController.isSignUpLoading.value
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
                                    "Signing Up...",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
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
                        'Already have an account? ',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to login screen
                          Get.back(); // or Get.toNamed(AppRoute.loginScreen);
                        },
                        child: Text(
                          'Login',
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
