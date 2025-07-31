class Urls {
  static const String baseUrl = 'https://majidfrih-backend.vercel.app/api/v1';
  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/users/register';
  static const String setupProfile = '$baseUrl/users/update-profile';
  static const String verifyOTP = '$baseUrl/auth/verify-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String userPofile = '$baseUrl/auth/profile';
  static const String getMyProducts = '$baseUrl/product/my-products';

  static const String websocketUrl = 'wss://fmqhx26q-5005.inc1.devtunnels.ms';

  // New URLs for delete and update
  static String deleteMyProduct(String productId) =>
      '$baseUrl/product/$productId';
  static String updateMyProduct(String productId) =>
      '$baseUrl/product/$productId';

  static const String authentication = '$baseUrl/auth/verify-auth';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPass = '$baseUrl/auth/forgot-password';
  static const String pickUpLocation = '$baseUrl/user/pickup-locations';
  static String getCalendar(String date, String locationUuid) =>
      '$baseUrl/calendar?date=$date&pickup_location_uuid=$locationUuid';
}
