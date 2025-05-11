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

  const SettingsMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
    this.itemType = SettingsItemType.normal,
    this.toggleValue = false,
    this.onToggleChanged,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use provided colors or defaults
    final bgColor = backgroundColor ?? const Color(0xFF1C1C1E);
    final txtColor = itemType == SettingsItemType.danger
        ? Colors.red
        : (textColor ?? Colors.white);
    final icnColor = itemType == SettingsItemType.danger
        ? Colors.red
        : (iconColor ?? Colors.white);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: InkWell(
        onTap: itemType == SettingsItemType.toggle ? null : onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              // Icon section
              Icon(
                icon,
                color: icnColor,
                size: 22.sp,
              ),
              SizedBox(width: 14.w),

              // Text section
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    color: txtColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),

              // Toggle switch or arrow indicator
              if (itemType == SettingsItemType.toggle)
                Switch(
                  value: toggleValue,
                  onChanged: onToggleChanged,
                  activeColor: Theme.of(context).primaryColor,
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
