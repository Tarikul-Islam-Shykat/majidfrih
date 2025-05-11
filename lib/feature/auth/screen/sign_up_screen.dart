import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/country_list.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/route/route.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var loginEmailController = TextEditingController();
    var loginPasswordController = TextEditingController();

    Map<String, String> selectedCountry = {
      "name": "France",
      "code": "+33",
      "icon": "🇫🇷",
    };

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
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Phone Number/Email",
                  ),
                  SizedBox(height: 10.h),
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Password",
                    // suffixIcon: Image.asset(ImagePath.passwordHidden),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
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
                                      // setState(() {
                                      //   selectedCountry = country;
                                      // });
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
                              //  color: Color(0xFFF1F6FF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  selectedCountry['icon'] ?? '',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16.sp, color: Colors.white),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  selectedCountry['code'] ?? '',
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
                            //  controller: signPhoneController,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Allow only digits
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
                          ),
                        ),
                      ],
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
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoute.subsCriptionScreen);
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
                        'Don’t have an account? ',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: AppColors.primaryColor,
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
