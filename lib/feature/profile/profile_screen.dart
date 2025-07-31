// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/screen/privacy_policy_page.dart';
import 'package:prettyrini/feature/auth/screen/terms_condition_page.dart';
import 'package:prettyrini/feature/get_my_products/UI/my_products_page.dart';
import 'package:prettyrini/feature/get_my_products/controller/get_my_controller.dart';
import 'package:prettyrini/feature/home/controller/product_controller.dart';
import 'package:prettyrini/feature/profile/widget/profile_widget.dart';
import 'package:prettyrini/route/route.dart';

class ProfileScreen extends StatelessWidget {
  // Get the ThemeController instance
  final ThemeController themeController = Get.find<ThemeController>();

  ProfileScreen({super.key});
  final EnhancedProductController productController =
      Get.put(EnhancedProductController());

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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(
                        () => buildAppBar(productController.nameObs.value,
                            productController.profileImageObs.value,
                            textColor: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
                          color: isDarkMode
                              ? Color(0xFF0E8898).withValues(alpha: 0.05)
                              : Color(0xFF0E8898).withValues(alpha: 0.05),
                        ),
                        child: Column(
                          children: [
                            // Account Edit
                            SettingsMenuItem(
                              icon: Icons.settings,
                              text: 'Account Edit',
                              textColor: iconTextColor,
                              iconColor: iconTextColor,
                              onTap: () => log('Account Edit tapped'),
                            ),

                            // Reset password
                            SettingsMenuItem(
                              icon: Icons.lock,
                              text: 'Reset password',
                              textColor: iconTextColor,
                              iconColor: iconTextColor,
                              onTap: () => log('Reset password tapped'),
                            ),

                            // Theme toggle
                            SettingsMenuItem(
                              icon: Icons.brightness_6,
                              text: isDarkMode ? 'Mode: Dark' : 'Mode: Light',
                              itemType: SettingsItemType.toggle,
                              textColor: iconTextColor,
                              iconColor: iconTextColor,
                              toggleValue: isDarkMode,
                              onToggleChanged: (value) {
                                themeController.toggleTheme();
                                log('Theme toggled: $value');
                              },
                              activeColor:
                                  isDarkMode ? Colors.black : Colors.white,
                              activeTrackColor:
                                  isDarkMode ? Colors.white : Colors.black,
                              inactiveTrackColor:
                                  isDarkMode ? Colors.white : Colors.white,
                            ),
                          ],
                        ),
                      ),

                      // About
                      // SettingsMenuItem(
                      //   icon: Icons.info_outline,
                      //   text: 'About',
                      //   textColor: iconTextColor,
                      //   iconColor: iconTextColor,
                      //   onTap: () => log('About tapped'),
                      // ),

                      SettingsMenuItem(
                        icon: Icons.production_quantity_limits,
                        text: 'My Products',
                        textColor: iconTextColor,
                        iconColor: iconTextColor,
                        onTap: () {
                          Get.to(MyProductsPage());
                          // final MyProductsController myProductsController =
                          //     Get.put(MyProductsController());
                          // myProductsController.getProductsData();
                        },
                      ),

                      // Terms and conditions
                      SettingsMenuItem(
                        icon: Icons.description_outlined,
                        text: 'Terms and condition',
                        textColor: iconTextColor,
                        iconColor: iconTextColor,
                        onTap: () async {
                          final result =
                              await Get.to(() => TermsAndConditionsPage());
                          if (result == true) {
                            // User accepted terms
                            print("Terms accepted!");
                          }
                        },
                      ),

                      // Privacy policy
                      SettingsMenuItem(
                        icon: Icons.shield_outlined,
                        text: 'Privacy policy',
                        textColor: iconTextColor,
                        iconColor: iconTextColor,
                        onTap: () async {
                          final result =
                              await Get.to(() => PrivacyPolicyPage());
                          if (result == true) {
                            // User accepted privacy policy
                            print("Privacy policy accepted!");
                          }
                        },
                      ),

                      // Subscription
                      SettingsMenuItem(
                        icon: Icons.card_giftcard,
                        text: 'Manage Subscription',
                        textColor: iconTextColor,
                        iconColor: iconTextColor,
                        onTap: () => log('Manage Subscription tapped'),
                      ),

                      // Logout
                      SettingsMenuItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          itemType: SettingsItemType.danger,
                          textColor: Colors.red,
                          iconColor: Colors.red,
                          onTap: () {
                            Get.offAllNamed(AppRoute.loginScreen);
                            //   log('Logout tapped');
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
