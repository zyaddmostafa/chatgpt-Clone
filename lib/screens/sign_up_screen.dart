import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/already_have_an_account.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/core/widgets/custom_divider.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpacing(44),
              Image.asset(
                Assets.assetsImagesSmallerAppIcon,
                color: Colors.black,
              ),
              verticalSpacing(24),
              Text('Create your account', style: AppTextstyles.font24Medium),
              verticalSpacing(16),
              Text(
                'Please note that phone verification is required for sign up. Your number will only be used to verify your identity for security purpose.',
                style: AppTextstyles.font12Regular,
                textAlign: TextAlign.center,
              ),
              verticalSpacing(32),

              CustomTextFormField(
                hintText: 'Email address',
                obscureText: false,
                onTap: () {},
              ),
              verticalSpacing(24),

              CustomTextFormField(
                hintText: 'Password',
                obscureText: false,
                onTap: () {},
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    Assets.assetsSvgsHideIcon,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {
                    // Add your toggle visibility logic here
                  },
                ),
              ),
              verticalSpacing(24),
              CustomAppButton(
                text: 'Continue',
                onPressed: () {
                  // Add your sign-up logic here
                },
              ),
              verticalSpacing(16),
              AlreadyHaveAnAccount(),
              verticalSpacing(36),
              CustomDivider(),
              Container(
                width: 327,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFFE5E6EB)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    SvgPicture.asset(
                      Assets.assetsSvgsGoogle,
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      'Continue with Google',
                      style: AppTextstyles.font16Regular,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
