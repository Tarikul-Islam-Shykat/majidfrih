import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/route/route.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class OtpVeryScreen extends StatefulWidget {
  const OtpVeryScreen({super.key});

  @override
  State<OtpVeryScreen> createState() => _OtpVeryScreenState();
}

class _OtpVeryScreenState extends State<OtpVeryScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

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
                  tilte_text_heading("OTP"),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => _buildOtpTextField(index),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          //  Get.toNamed(AppRoute.emailVerificationScreen);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Resend OTP',
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
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoute.setPasswordScreen);
                    },
                    title: Text(
                      "Enter",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
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

  Widget _buildOtpTextField(int index) {
    return Container(
      width: 40.h,
      height: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 18.sp, color: Colors.white),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          // Auto focus to next field when this field is filled
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          setState(() {});
        },
      ),
    );
  }
}
