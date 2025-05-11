import 'package:get/get.dart';
import 'package:prettyrini/feature/auth/screen/new_password.dart';
import 'package:prettyrini/feature/auth/screen/otp_very_screen.dart';
import 'package:prettyrini/feature/auth/screen/sign_up_screen.dart';
import 'package:prettyrini/feature/dashboard/ui/dashboard.dart';
import 'package:prettyrini/feature/subscription_page/view/subscription_screen.dart';
import 'package:prettyrini/feature/welome/view/welcome_screen.dart';
import '../feature/auth/screen/forget_pasword_screen.dart';
import '../feature/auth/screen/login_screen.dart';
import '../feature/auth/screen/reset_password.dart';
import '../feature/splash_screen/screen/splash_screen.dart';

class AppRoute {
  static String splashScreen = '/splashScreen';
  static String forgetScreen = "/forgetScreen";
  static String resetPassScreen = "/resetPassScreen";

  static String welcomeScreen = "/welcomeScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String resetPassowrd = "/resetPasswordScreen";
  static String otpScreen = "/otpScreen";
  static String subsCriptionScreen = "/subScriptionScreen";
  static String setPasswordScreen = "/setPasswordScreen";
  static String dashBoardScreen = "/dashboardScreen";

  static String getwelcomeScreen() => welcomeScreen;
  static String getloginScreen() => loginScreen;
  static String getsignUpScreen() => signUpScreen;
  static String getresetPassowrd() => resetPassowrd;
  static String getotpScreen() => otpScreen;
  static String getsubsCriptionScreen() => subsCriptionScreen;
  static String getsetPasswordScreen() => setPasswordScreen;
  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  static String getForgetScreen() => forgetScreen;
  static String getResetPassScreen() => resetPassScreen;
  static String getDashboardScreen() => dashBoardScreen;

  static List<GetPage> routes = [
    GetPage(name: dashBoardScreen, page: () => const DashboardScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: otpScreen, page: () => const OtpVeryScreen()),
    GetPage(name: subsCriptionScreen, page: () => const SubscriptionScreen()),
    GetPage(name: setPasswordScreen, page: () => const NewPasswordScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: forgetScreen, page: () => const ForgetPasswordScreen()),
    GetPage(name: resetPassScreen, page: () => ResetPassword()),
  ];
}
