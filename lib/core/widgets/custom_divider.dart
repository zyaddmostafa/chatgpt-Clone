import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColor.lightGreyColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('OR', style: AppTextstyles.font14Regular),
        ),
        Expanded(child: Divider(color: AppColor.lightGreyColor, thickness: 1)),
      ],
    );
  }
}
