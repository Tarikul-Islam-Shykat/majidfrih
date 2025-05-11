// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool isDarkMode = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF2F2F7),
//       appBar: AppBar(
//         title: Text(
//           'Settings',
//           style: TextStyle(
//             color: isDarkMode ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: isDarkMode ? Colors.black : Colors.white,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(
//             children: [
//               SizedBox(height: 16.h),
              
//               // Account settings section
//               SettingsMenuItem(
//                 icon: Icons.settings,
//                 text: 'Account Edit',
//                 isDarkMode: isDarkMode,
//                 onTap: () {
//                   print('Account Edit tapped');
//                 },
//               ),
              
//               SettingsMenuItem(
//                 icon: Icons.lock,
//                 text: 'Reset password',
//                 isDarkMode: isDarkMode,
//                 onTap: () {
//                   print('Reset password tapped');
//                 },
//               ),
              
//               // Appearance settings
//               SettingsMenuItem(
//                 icon: Icons.brightness_6,
//                 text: isDarkMode ? 'Mode: Dark' : 'Mode: Light',
//                 isDarkMode: isDarkMode,
//                 itemType: SettingsItemType.toggle,
//                 toggleValue: isDarkMode,
//                 onToggleChanged: (value) {
//                   setState(() {
//                     isDarkMode = value;
//                   });
//                   print('Dark mode: $value');
//                 },
//               ),
              
//               // Information section
//               SettingsMenuItem(
//                 icon: Icons.info_outline,
//                 text: 'About',
//                 isDarkMode: isDarkMode,
//                 onTap: () {
//                   print('About tapped');
//                 },
//               ),
              
//               SettingsMenuItem(
//                 icon: Icons.description_outlined,
//                 text: 'Terms and condition',
//                 isDarkMode: isDarkMode,
//                 onTap: () {
//                   print('Terms and condition tapped');
//                 },
//               ),
              
//               SettingsMenuItem(
//                 icon: Icons.shield_outlined,
//                 text: 'Privacy policy',
//                 isDarkMode: isDarkMode,
//                 onTap: () {
//                   print('Privacy policy tapped');
//                 },
//               ),
              
//               // Subscription
//               SettingsMenuItem(
//                 icon: Icons.card_giftcard,
//                 text: 'Manage Subscription',
//                 isDarkMode: isDarkMode,
//                 onTap: () {
//                   print('Manage Subscription tapped');
//                 },
//               ),
              
//               // Logout (danger item)
//               SettingsMenuItem(
//                 icon: Icons.logout,
//                 text: 'Logout',
//                 isDarkMode: isDarkMode,
//                 itemType: SettingsItemType.danger,
//                 onTap: () {
//                   print('Logout tapped');
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }