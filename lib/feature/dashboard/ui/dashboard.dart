// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:prettyrini/feature/chat_v2/view/chat_list.dart';
import 'package:prettyrini/feature/dashboard/controller/navigation_controller.dart';
import 'package:prettyrini/feature/home/ui/product_home_screen.dart';
import 'package:prettyrini/feature/post/ui/post_ui.dart';
import 'package:prettyrini/feature/profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    final NavigationController navController = Get.put(NavigationController());
    final ChatController chatController = Get.put(ChatController());

    final List<Widget> screens = [
      ProductHomeScreen(),
      PostScreen(),
      UsersChatList(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background based on selected tab
          Obx(() {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: navController.selectedIndex.value == 0
                      ? [const Color(0xFF1A1A1A), const Color(0xFF003344)]
                      : navController.selectedIndex.value == 1
                          ? [const Color(0xFF1A1A1A), const Color(0xFF332244)]
                          : navController.selectedIndex.value == 2
                              ? [
                                  const Color(0xFF1A1A1A),
                                  const Color(0xFF334411)
                                ]
                              : [
                                  const Color(0xFF1A1A1A),
                                  const Color(0xFF223344)
                                ],
                ),
              ),
            );
          }),

          // Screen Content
          Obx(() => screens[navController.selectedIndex.value]),

          // Blurred Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                //borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Color(0xFF0E8898).withValues(alpha: 0.05)
                          : Colors.black, // Bottom NavBar er jonno
                      //borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNavItem(
                                0,
                                Icons.home,
                                'Home',
                                isDarkMode
                                    ? Color(0xFF0E8898)
                                    : Color(0xFF0E8898),
                                navController),
                            _buildNavItem(
                                1,
                                Icons.add_box,
                                'Add',
                                isDarkMode
                                    ? Color(0xFF0E8898)
                                    : Color(0xFF0E8898),
                                navController),
                            _buildNavItem(
                                2,
                                Icons.chat_bubble,
                                'Chat',
                                isDarkMode
                                    ? Color(0xFF0E8898)
                                    : Color(0xFF0E8898),
                                navController),
                            _buildNavItem(
                                3,
                                Icons.person,
                                'Profile',
                                isDarkMode
                                    ? Color(0xFF0E8898)
                                    : Color(0xFF0E8898),
                                navController),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconData, String label,
      Color iconColor, NavigationController controller) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    bool isSelected = controller.selectedIndex.value == index;
    return InkWell(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: isSelected
            ? BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                // color: isDarkMode ? Colors.black : Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(40),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: isSelected ? iconColor : Colors.white,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? iconColor : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
