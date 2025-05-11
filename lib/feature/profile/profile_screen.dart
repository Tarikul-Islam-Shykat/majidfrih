// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/profile/widget/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          // Background
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              ImagePath.subscriptionLogo,
              fit: BoxFit.fill,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildAppBar("Jenny"),
                  SizedBox(
                    height: 20,
                  ),

                  SettingsMenuItem(
                    icon: Icons.settings,
                    text: 'Account Edit',
                    textColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      print('Account Edit tapped');
                    },
                  ),

                  SettingsMenuItem(
                    icon: Icons.lock,
                    text: 'Reset password',
                    textColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      print('Reset password tapped');
                    },
                  ),

                  // Appearance settings
                  // SettingsMenuItem(
                  //   icon: Icons.brightness_6,
                  //   text: isDarkMode ? 'Mode: Dark' : 'Mode: Light',
                  //   backgroundColor: backgroundColor,
                  //   textColor: textColor,
                  //   iconColor:
                  //       isDarkMode ? Colors.white : const Color(0xFF007AFF),
                  //   itemType: SettingsItemType.toggle,
                  //   toggleValue: isDarkMode,
                  //   onToggleChanged: (value) {
                  //     setState(() {
                  //       isDarkMode = value;
                  //     });
                  //     print('Dark mode: $value');
                  //   },
                  // ),

                  SettingsMenuItem(
                    icon: Icons.brightness_6,
                    text: 'Mode: Dark',
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    itemType: SettingsItemType.toggle,
                    textColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onToggleChanged: (value) {
                      // setState(() {
                      //   isDarkMode = value;
                      // });
                      print('Dark mode: $value');
                    },
                  ),

                  // Information section
                  SettingsMenuItem(
                    icon: Icons.info_outline,
                    text: 'About',
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      print('About tapped');
                    },
                  ),

                  SettingsMenuItem(
                    icon: Icons.description_outlined,
                    text: 'Terms and condition',
                    textColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      print('Terms and condition tapped');
                    },
                  ),

                  SettingsMenuItem(
                    icon: Icons.shield_outlined,
                    text: 'Privacy policy',
                    textColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      print('Privacy policy tapped');
                    },
                  ),

                  // Subscription
                  SettingsMenuItem(
                    icon: Icons.card_giftcard,
                    text: 'Manage Subscription',
                    iconColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    textColor: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      print('Manage Subscription tapped');
                    },
                  ),

                  // Logout (danger item)
                  SettingsMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    itemType: SettingsItemType.danger,
                    onTap: () {
                      print('Logout tapped');
                    },
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
