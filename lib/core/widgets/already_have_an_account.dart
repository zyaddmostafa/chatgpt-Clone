import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccountOrCreateAccount extends StatelessWidget {
  final String title, navigationText;
  final void Function()? onTap;
  const AlreadyHaveAnAccountOrCreateAccount({
    super.key,
    required this.title,
    required this.navigationText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppTextstyles.font14Medium),
        horizontalSpacing(4),
        InkWell(
          onTap: onTap,
          child: Text(
            navigationText,
            style: AppTextstyles.font14Medium.copyWith(
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
