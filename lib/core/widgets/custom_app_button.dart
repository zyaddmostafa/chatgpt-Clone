import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    this.color,
    this.borderColor,
    this.textColor,
    this.onPressed,
    required this.text,
  });
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              color ?? AppColor.primaryColor,
            ),
            side: WidgetStatePropertyAll(
              BorderSide(color: borderColor ?? AppColor.primaryColor, width: 1),
            ),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              text,
              style: AppTextstyles.font16Medium.copyWith(
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
