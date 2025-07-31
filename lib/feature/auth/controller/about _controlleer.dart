import 'package:get/get.dart';
import 'package:prettyrini/feature/auth/screen/about_pop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUsController extends GetxController {
  static const String _aboutUsShownKey = 'about_us_popup_shown';

  @override
  void onInit() {
    super.onInit();
    _checkAndShowAboutUs();
  }

  void _checkAndShowAboutUs() async {
    // Check if about us popup has been shown before
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool(_aboutUsShownKey) ?? false;

    if (!hasShown) {
      // Delay to ensure the main screen is loaded
      Future.delayed(Duration(milliseconds: 800), () {
        _showAboutUsPopup();
      });
    }
  }

  void _showAboutUsPopup() {
    Get.dialog(
      AboutUsPopup(),
      barrierDismissible: false,
    );
  }

  void closePopup() async {
    // Mark as shown so it won't appear again
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_aboutUsShownKey, true);
    Get.back();
  }

  // Method to manually show popup (for testing or settings)
  void showAboutUsManually() {
    Get.dialog(
      AboutUsPopup(),
      barrierDismissible: true,
    );
  }

  // Method to reset popup (for testing purposes)
  void resetAboutUsPopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_aboutUsShownKey);
  }
}
