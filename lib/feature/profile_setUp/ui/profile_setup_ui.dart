import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/screen/login_screen.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/feature/profile_setUp/controller/profile_setup_controller.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final ProfileEditController profileController =
        Get.put(ProfileEditController());

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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // App Bar
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'EDIT PROFILE',
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 48), // Balance the back button
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // Profile Image Section
                    Obx(() => GestureDetector(
                          onTap: () {
                            profileController.showImagePickerDialog();
                          },
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 3,
                              ),
                            ),
                            child: profileController.selectedImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60.w),
                                    child: Image.file(
                                      profileController.selectedImage.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 40.sp,
                                    color: Colors.grey[600],
                                  ),
                          ),
                        )),

                    SizedBox(height: 10.h),

                    Text(
                      'Tap to select profile image',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Form Fields
                    Column(
                      children: [
                        // Username Field
                        Obx(() => CustomAuthField(
                              controller: profileController.userNameController,
                              hintText: "Username",
                              borderColor:
                                  profileController.isUserNameValid.value
                                      ? Colors.grey
                                      : Colors.red,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: themeController.isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            )),
                        SizedBox(height: 15.h),

                        // Phone Number Field
                        Obx(() => CustomAuthField(
                              controller:
                                  profileController.phoneNumberController,
                              readOnly: true,
                              hintText: "Phone Number",
                              borderColor:
                                  profileController.isPhoneNumberValid.value
                                      ? Colors.grey
                                      : Colors.red,
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: themeController.isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            )),
                        SizedBox(height: 15.h),

                        // Email Field (Read-only)
                        CustomAuthField(
                          controller: profileController.emailController,
                          hintText: "Email",
                          borderColor: Colors.grey,
                          //  enabled: false, // Make it read-only
                          readOnly: true,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Email info text
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email cannot be changed',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Update Button
                        Obx(() => CustomButton(
                              onTap: profileController.isUpdateLoading.value
                                  ? null
                                  : () async {
                                      final success = await profileController
                                          .updateProfile();
                                      if (success) {
                                        // Navigate back or show success
                                        Get.to(LoginScreen());
                                        //  Get.back();
                                      }
                                    },
                              title: profileController.isUpdateLoading.value
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Updating...",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      "UPDATE PROFILE",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            )),

                        // Debug button for testing (remove in production)
                        if (Get.isRegistered<ProfileEditController>())
                          SizedBox(height: 15.h),
                        if (Get.isRegistered<ProfileEditController>())
                          TextButton(
                            onPressed: () {
                              profileController.fillTestData();
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
