// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/const/sizer.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';

class ChatDetailScreen extends StatelessWidget {
  final String contactName;

  ChatDetailScreen({Key? key, required this.contactName}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDarkMode = themeController.isDarkMode;
      final Color iconTextColor = isDarkMode ? Colors.white : Colors.black;
      final Color bgColor = AppColors.primaryColor;

      return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  isDarkMode
                      ? ImagePath.subscriptionLogo
                      : ImagePath.subscriptionLogol,
                  fit: BoxFit.fill,
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom app bar for ChatDetailScreen with "Jenny" and "Active"
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: iconTextColor.withOpacity(0.2),
                                ),
                                child: Image.asset(ImagePath.profile),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jenny",
                                    style: TextStyle(
                                      color: iconTextColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Text(
                                        "Active",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Icon(
                                        Icons.circle,
                                        size: 10.sp,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: isDarkMode
                                ? Color(0xFF0E8898).withValues(alpha: 0.05)
                                : Color(0xFF0E8898).withValues(alpha: 0.05),
                            child: IconButton(
                              icon: Icon(
                                size: 40.r,
                                Icons.search,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF0E8898).withValues(alpha: 0.05),
                        ),
                        child: _buildMessageInputField(context)),
                  ],
                ),
              ),
            ],
          ));
    });
  }

  Widget _buildMessageInputField(BuildContext context) {
    final bool isDarkMode = themeController.isDarkMode;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthPercent(context, 4),
        vertical: SizeConfig.heightPercent(context, 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Color(0xFFA3A3A3).withValues(alpha: 0.10),
              ),
              child: TextField(
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode ? Color(0xFF171717) : Colors.white,
                  hintText: 'Message',
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? Color(0xFFFFFFFF).withValues(alpha: 0.25)
                        : Color(0xFF171717).withValues(alpha: 0.25),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: SizeConfig.widthPercent(context, 2)),
          CircleAvatar(
            backgroundColor:
                isDarkMode ? Color(0xFF171717) : AppColors.containerLight,
            radius: 28.r,
            child: Image.asset(ImagePath.send, height: 30, width: 30),
          ),
        ],
      ),
    );
  }
}
