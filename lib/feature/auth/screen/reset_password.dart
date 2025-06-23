import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/controller/reset_password_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/route/route.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final ResetPasswordController resetPasswordController =
        Get.put(ResetPasswordController());

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
                  tilte_text_heading("Reset Password"),
                  SizedBox(height: 50.h),
                  CustomAuthField(
                    controller: resetPasswordController.emailController,
                    hintText: "Email",
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.back(); // Go back to login screen
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Remember Password?',
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
                  Obx(() => CustomButton(
                        onTap: resetPasswordController.isResetLoading.value
                            ? null
                            : () async {
                                final success = await resetPasswordController
                                    .resetPassword();
                                if (success) {
                                  // Navigate to OTP screen or back to login
                                  Get.toNamed(AppRoute.otpScreen);
                                }
                              },
                        title: resetPasswordController.isResetLoading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Sending...",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Send Reset Link",
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
        ],
      ),
    );
  }
}
