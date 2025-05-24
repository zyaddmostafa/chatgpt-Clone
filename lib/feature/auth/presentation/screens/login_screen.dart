import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/already_have_an_account.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_divider.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/social_media_auth.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/login_button_bloc_consumer.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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

                LoginForm(),

                verticalSpacing(24),
                LoginButtonBlocConsumer(),
                verticalSpacing(16),
                AlreadyHaveAnAccountOrCreateAccount(
                  title: 'You don\'t have an account?',
                  navigationText: 'Signup',
                  onTap:
                      () => context.pushReplacementNamed(Routes.signupScreen),
                ),
                verticalSpacing(36),
                CustomDivider(),
                verticalSpacing(24),
                SocialMediaAuth(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
