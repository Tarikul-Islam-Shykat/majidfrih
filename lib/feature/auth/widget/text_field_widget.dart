import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/style/global_text_style.dart';

class CustomAuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? prefixIcon;
  final int maxLines;
  final double radiusValue;
  final double radiusValue2;
  final bool isDigitOnly;

  // New theme-related parameters
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;

  const CustomAuthField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.validator,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.radiusValue = 500,
    this.radiusValue2 = 500,
    this.isDigitOnly = false,

    // Optional theming
    this.textColor,
    this.hintColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor = textColor ?? Colors.white;
    final Color effectiveHintColor = hintColor ?? Colors.grey;
    final Color effectiveBorderColor = borderColor ?? Colors.grey;

    return SizedBox(
      child: TextFormField(
        readOnly: readOnly,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        maxLines: maxLines,
        inputFormatters: [
          if (isDigitOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        style: globalTextStyle(color: effectiveTextColor),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: globalTextStyle(
            color: effectiveHintColor,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          fillColor: Colors.transparent,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: effectiveBorderColor, width: 2),
            borderRadius: BorderRadius.circular(radiusValue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: effectiveBorderColor, width: 2),
            borderRadius: BorderRadius.circular(radiusValue2),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 14.w,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
