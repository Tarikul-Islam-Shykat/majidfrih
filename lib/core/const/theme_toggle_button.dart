import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  final ThemeController themeController;
  
  const ThemeToggleButton({
    Key? key,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return IconButton(
          icon: Icon(
            controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: controller.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            controller.toggleTheme();
          },
        );
      },
    );
  }
}
