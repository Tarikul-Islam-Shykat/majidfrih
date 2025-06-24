import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/controller/otp_verification_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class OtpVeryScreen extends StatefulWidget {
  const OtpVeryScreen({super.key});

  @override
  State<OtpVeryScreen> createState() => _OtpVeryScreenState();
}

class _OtpVeryScreenState extends State<OtpVeryScreen> {
  late final OtpController otpController;

  @override
  void initState() {
    super.initState();
    // Initialize OTP controller
    otpController = Get.put(OtpController());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

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
                  tilte_text_heading("OTP Verification"),
                  SizedBox(height: 20.h),

                  // Display email if available
                  Obx(
                    () => otpController.email.value.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              'Enter the 4-digit code sent to\n${otpController.email.value}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: themeController.isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 30.h),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => _buildOtpTextField(index, themeController),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Resend OTP Section
                  // Row(
                  //   children: [
                  //     const Spacer(),
                  //     Obx(() => GestureDetector(
                  //       onTap: otpController.isResendLoading.value
                  //         ? null
                  //         : () async {
                  //             await otpController.resendOtp();
                  //           },
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: 12.w,
                  //           vertical: 8.h
                  //         ),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(20.r),
                  //           border: Border.all(
                  //             color: themeController.isDarkMode
                  //                 ? Colors.white30
                  //                 : Colors.black30,
                  //           ),
                  //         ),
                  //         child: otpController.isResendLoading.value
                  //           ? SizedBox(
                  //               width: 16.w,
                  //               height: 16.h,
                  //               child: CircularProgressIndicator(
                  //                 strokeWidth: 2,
                  //                 valueColor: AlwaysStoppedAnimation<Color>(
                  //                   themeController.isDarkMode
                  //                       ? Colors.white
                  //                       : Colors.black,
                  //                 ),
                  //               ),
                  //             )
                  //           : Text(
                  //               'Resend OTP',
                  //               style: GoogleFonts.poppins(
                  //                 fontSize: 13.sp,
                  //                 color: themeController.isDarkMode
                  //                     ? Colors.white
                  //                     : Colors.black,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //       ),
                  //     )),
                  //   ],
                  // ),

                  SizedBox(height: 30.h),

                  // Verify Button
                  Obx(() => CustomButton(
                        onTap: otpController.isVerifyLoading.value
                            ? null
                            : () async {
                                final success = await otpController.verifyOtp();
                                if (success) {
                                  // Navigate to next screen or show success
                                  log("OTP verification successful");
                                }
                              },
                        title: otpController.isVerifyLoading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Verifying...",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Verify OTP",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),

                  SizedBox(height: 20.h),

                  // Back Button
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Back to Login',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                        decoration: TextDecoration.underline,
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

  Widget _buildOtpTextField(int index, ThemeController themeController) {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeController.isDarkMode
              ? Colors.white30
              : Colors.grey.shade400,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
        color: themeController.isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.8),
      ),
      child: TextField(
        controller: otpController.otpControllers[index],
        focusNode: otpController.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: '0',
          hintStyle: TextStyle(
            color: themeController.isDarkMode
                ? Colors.white30
                : Colors.grey.shade400,
            fontSize: 20.sp,
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          otpController.onOtpChanged(value, index);
          setState(() {}); // Update UI for visual feedback
        },
        onTap: () {
          // Clear the field when tapped for better UX
          otpController.otpControllers[index].selection =
              TextSelection.fromPosition(
            TextPosition(
                offset: otpController.otpControllers[index].text.length),
          );
        },
      ),
    );
  }
}
