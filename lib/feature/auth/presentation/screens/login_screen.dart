import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/already_have_an_account.dart';
import 'package:chatgpt/core/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/core/widgets/custom_divider.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/core/widgets/social_media_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AuthHeader(title: 'Welcome Back!'),
              verticalSpacing(16),
              Text(
                'Log in to continue exploring, managing your account, and accessing personalized features.',
                style: AppTextstyles.font12Regular,
                textAlign: TextAlign.center,
              ),
              verticalSpacing(32),

              CustomTextFormField(
                hintText: 'Email address',
                obscureText: false,
              ),
              verticalSpacing(24),

              CustomTextFormField(
                hintText: 'Password',
                obscureText: false,

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
                  context.pushReplacementNamed(Routes.enterNameScreen);
                },
              ),
              verticalSpacing(16),
              AlreadyHaveAnAccountOrCreateAccount(
                title: 'You don\'t have an account?',
                navigationText: 'Signup',
              ),
              verticalSpacing(36),
              CustomDivider(),
              verticalSpacing(24),
              SocialMediaAuth(),
            ],
          ),
        ),
      ),
    );
  }
}
