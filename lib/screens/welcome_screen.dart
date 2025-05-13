import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 233.h,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Image.asset(
                Assets.assetsImagesSmallerAppIcon,
                color: Colors.white,
              ),
            ),
            verticalSpacing(56),
            Text('Welcome to ChatGPT', style: AppTextstyles.font20Medium),
            verticalSpacing(16),
            Text(
              'Log in with your OpenAI account to continue',
              style: AppTextstyles.font14Regular,
            ),
            verticalSpacing(36),
            CustomAppButton(text: 'LOG IN'),
            verticalSpacing(24),
            CustomAppButton(
              text: 'SIGN UP',
              color: Colors.white,
              borderColor: AppColor.primaryColor,
              textColor: AppColor.primaryColor,
              onPressed:
                  () => context.pushReplacementNamed(Routes.signupScreen),
            ),
          ],
        ),
      ),
    );
  }
}
