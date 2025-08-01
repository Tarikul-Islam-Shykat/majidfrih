import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/theme_toggle_button.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/controller/about%20_controlleer.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/route/route.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AboutUsController controller2 = Get.put(AboutUsController());
    });
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              themeController.isDarkMode
                  ? ImagePath.splash_d
                  : ImagePath.splash_l,
              fit: BoxFit.fill,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome\nTo",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ThemeToggleButton(themeController: themeController),
                SizedBox(height: 20.h),
                tilte_text_heading("HandToHand"),
                SizedBox(height: 20.h),
                Text(
                  "A secure way to buy and sell items with\nhand-delivery. Connect directly with\nlocal sellers.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ],
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
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoute.loginScreen);
                    },
                    title: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoute.signUpScreen);
                    },
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    title: Text(
                      "Signup",
                      style: GoogleFonts.poppins(
                        color: themeController.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
