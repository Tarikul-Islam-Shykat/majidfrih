import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/screen/new_password.dart';
import 'package:prettyrini/feature/auth/screen/otp_very_screen.dart';
import 'package:prettyrini/feature/auth/screen/reset_password.dart';
import 'package:prettyrini/feature/home/ui/product_home_screen.dart';
import 'package:prettyrini/feature/post/ui/post_ui.dart';
import 'package:prettyrini/feature/welome/view/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/const/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  configEasyLoading();
  await SharedPreferences.getInstance();

  Get.put(ThemeController());
  runApp(const MyApp());
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.grayColor
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetBuilder<ThemeController>(
        builder: (themeController) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HandToHand',
            // Use themeMode based on the controller value
            themeMode:
                themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            // Define your light theme
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue,
              // Add other theme properties
            ),
            // Define your dark theme
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blueAccent,
            ),
            home: ProductHomeScreen(),
            //home: WelcomeScreen(),
            // home: OtpVeryScreen(),
            // home: NewPasswordScreen(),
            // home: PostScreen(),
          );
        },
      ),
    );
  }
}
