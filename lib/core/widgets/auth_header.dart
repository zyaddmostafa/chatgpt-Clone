import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpacing(44),
        Image.asset(Assets.assetsImagesSmallerAppIcon, color: Colors.black),
        verticalSpacing(24),
        Text(title, style: AppTextstyles.font24Medium),
      ],
    );
  }
}
