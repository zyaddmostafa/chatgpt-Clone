import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final VoidCallback onTap;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.obscureText,
    required this.onTap,
    this.keyboardType,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: contentPadding,

        hintText: hintText,
        hintStyle: AppTextstyles.font16Regular,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColor.lightGreyColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),

          borderSide: BorderSide(color: AppColor.lightGreyColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText ?? false,
    );
  }
}
