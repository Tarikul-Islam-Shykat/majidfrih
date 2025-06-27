// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/core/global_widegts/network_image.dart';

Widget buildAppBar(String username, String imaegPath,
    {required Color textColor}) {
  final ThemeController themeController = Get.find<ThemeController>();
  final bool isDarkMode = themeController.isDarkMode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ResponsiveNetworkImage(
              imageUrl: imaegPath,
              shape: ImageShape.roundedRectangle,
              borderRadius: 12,
              widthPercent: 0.15,
              heightPercent: 0.08,
              fit: BoxFit.cover,
              placeholderWidget: CircularProgressIndicator(),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  username,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // CircleAvatar(
            //   radius: 30.r,
            //   backgroundColor: isDarkMode
            //       ? Color(0xFF0E8898).withValues(alpha: 0.05)
            //       : Color(0xFF0E8898).withValues(alpha: 0.05),
            //   child: IconButton(
            //     icon: Icon(
            //       size: 30.r,
            //       Icons.search,
            //       color: isDarkMode ? Colors.white : Colors.black,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            const SizedBox(width: 10),
            // Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: textColor.withOpacity(0.1),
            //   ),
            //   child: IconButton(
            //     icon: Icon(Icons.notifications_outlined, color: textColor),
            //     onPressed: () {},
            //   ),
            // ),
            CircleAvatar(
              radius: 30.r,
              backgroundColor: isDarkMode
                  ? Color(0xFF0E8898).withValues(alpha: 0.05)
                  : Color(0xFF0E8898).withValues(alpha: 0.05),
              child: IconButton(
                icon: Icon(
                  size: 30.r,
                  Icons.notifications_outlined,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
