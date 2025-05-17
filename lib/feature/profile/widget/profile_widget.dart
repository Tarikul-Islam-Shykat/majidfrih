// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SettingsItemType {
  normal,
  toggle,
  danger,
}

class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onTap;
  final SettingsItemType itemType;
  final bool toggleValue;
  final Function(bool)? onToggleChanged;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.itemType = SettingsItemType.normal,
    this.toggleValue = false,
    this.onToggleChanged,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color containerColor = backgroundColor ??
        (isDarkMode
            ? const Color(0xFF0E8898).withValues(alpha: 0.05)
            : const Color(0xFF0E8898).withValues(alpha: 0.05));

    final Color txtColor = itemType == SettingsItemType.danger
        ? Colors.red
        : (textColor ?? (isDarkMode ? Colors.white : Colors.black));

    final Color icnColor = itemType == SettingsItemType.danger
        ? Colors.red
        : (iconColor ?? (isDarkMode ? Colors.white : Colors.black));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.h),
      child: InkWell(
        onTap: itemType == SettingsItemType.toggle ? null : onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: icnColor,
                size: 22.sp,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    color: txtColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              if (itemType == SettingsItemType.toggle)
                Switch(
                  value: toggleValue,
                  onChanged: onToggleChanged,
                  thumbColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      // switch on (toggle on)
                      return isDarkMode ? Color(0xFF0E8898) : Colors.white;
                    }
                    return isDarkMode ? Colors.white : Color(0xFF0E8898);
                  }),
                  trackColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return isDarkMode ? Colors.white : Color(0xFF0E8898);
                    }
                    return isDarkMode ? Colors.white : Colors.black;
                  }),
                )
              else if (itemType == SettingsItemType.normal)
                Icon(
                  Icons.arrow_forward_ios,
                  color: txtColor.withOpacity(0.5),
                  size: 16.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
