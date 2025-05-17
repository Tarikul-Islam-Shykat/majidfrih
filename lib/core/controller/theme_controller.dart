import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Private observable for dark mode
  final RxBool _isDarkMode = false.obs;

  // Public observable to listen to theme changes
  RxBool get isDarkModeObs => _isDarkMode;

  // Convenience getter for quick access
  bool get isDarkMode => _isDarkMode.value;

  static const String _themeKey = 'is_dark_mode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs(); // Load saved theme when controller initializes
  }

  /// Loads the theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool(_themeKey) ?? false;
    _isDarkMode.value = savedTheme;
    _applyTheme();
  }

  /// Saves the theme preference to SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode.value);
  }

  /// Toggles the current theme between dark and light
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToPrefs();
    _applyTheme();
  }

  /// Sets theme explicitly (true for dark, false for light)
  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    _saveThemeToPrefs();
    _applyTheme();
  }

  /// Applies theme using GetX
  void _applyTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    // Optional: force rebuild for parts not using Obx
    Get.forceAppUpdate();
  }
}
