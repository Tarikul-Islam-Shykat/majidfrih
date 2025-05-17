import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // <-- Added this
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';

class PostScreen extends StatelessWidget {
  var loginEmailController = TextEditingController();
  final ThemeController themeController = Get.find<ThemeController>();

  // Rx to hold selected image file
  final Rx<File?> selectedImage = Rx<File?>(null);

  PostScreen({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final Color iconTextColor = isDarkMode ? Colors.white : Colors.black;
      final Color bgColor = isDarkMode ? Colors.black : AppColors.primaryColor;
      final Color fieldBorderColor =
          isDarkMode ? Colors.white24 : Colors.grey.shade400;
      final Color fieldTextColor = isDarkMode ? Colors.white : Colors.black;
      final Color fieldHintColor = isDarkMode ? Colors.white60 : Colors.grey;
      final String bgImage =
          isDarkMode ? ImagePath.subscriptionLogo : ImagePath.subscriptionLogol;

      return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // Background image
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                bgImage,
                fit: BoxFit.fill,
              ),
            ),

            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildAppBar("Jenny", textColor: iconTextColor),
                    SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                height: 100.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: fieldBorderColor, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  image: selectedImage.value != null
                                      ? DecorationImage(
                                          image:
                                              FileImage(selectedImage.value!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: selectedImage.value == null
                                    ? Center(
                                        child: Text(
                                          "Image",
                                          style:
                                              TextStyle(color: iconTextColor),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Product Name
                            CustomAuthField(
                              controller: loginEmailController,
                              hintText: "Product Name",
                              maxLines: 1,
                              textColor: fieldTextColor,
                              hintColor: fieldHintColor,
                              borderColor: fieldBorderColor,
                            ),
                            SizedBox(height: 20),

                            // Product Price
                            CustomAuthField(
                              controller: loginEmailController,
                              hintText: "Product Price",
                              maxLines: 1,
                              textColor: fieldTextColor,
                              hintColor: fieldHintColor,
                              borderColor: fieldBorderColor,
                            ),
                            SizedBox(height: 20),

                            // Description
                            CustomAuthField(
                              controller: loginEmailController,
                              hintText: "Product Description",
                              maxLines: 5,
                              radiusValue2: 20,
                              radiusValue: 20,
                              textColor: fieldTextColor,
                              hintColor: fieldHintColor,
                              borderColor: fieldBorderColor,
                            ),
                            SizedBox(height: 20),

                            // Category
                            CustomAuthField(
                              controller: loginEmailController,
                              hintText: "Product Category",
                              maxLines: 1,
                              textColor: fieldTextColor,
                              hintColor: fieldHintColor,
                              borderColor: fieldBorderColor,
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    // Post Button
                    CustomButton(
                      onTap: () {
                        // Handle post logic here, you can access selectedImage.value for the image file
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.post_add, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Post",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
