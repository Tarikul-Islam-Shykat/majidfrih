// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/chatbox/chat_list.dart';
import 'package:prettyrini/feature/dashboard/controller/navigation_controller.dart';
import 'package:prettyrini/feature/home/ui/product_home_screen.dart';
import 'package:prettyrini/feature/post/ui/post_ui.dart';
import 'package:prettyrini/feature/profile/profile_screen.dart';

// Navigation Controller

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    // Initialize the controller
    final NavigationController navController = Get.put(NavigationController());

    // List of screens
    final List<Widget> screens = [
      ProductHomeScreen(),
      PostScreen(),
      ChatScreen(),
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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

// Content screens
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Home',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 20),
                  _buildContentCard(context),
                  const SizedBox(height: 16),
                  _buildContentCard(context),
                  const SizedBox(height: 16),
                  _buildContentCard(context),
                  const SizedBox(height: 100), // Space for navigation bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Title',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Learn More'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddContent extends StatelessWidget {
  const AddContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            size: 100,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 20),
          Text(
            'Add New Content',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

// class ChatContent extends StatelessWidget {
//   const ChatContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.chat_bubble_outline,
//             size: 100,
//             color: Colors.white.withOpacity(0.8),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Chats',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//         ],
//       ),
//     );
//   }
// }

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 100,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 20),
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
