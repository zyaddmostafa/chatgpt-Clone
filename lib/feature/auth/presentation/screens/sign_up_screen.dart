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
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthHeader(title: 'Create your account'),
                verticalSpacing(16),
                Text(
                  'Please note that phone verification is required for sign up. Your number will only be used to verify your identity for security purpose.',
                  style: AppTextstyles.font12Regular,
                  textAlign: TextAlign.center,
                ),
                verticalSpacing(32),

                SignUpForm(),
                verticalSpacing(24),
                CustomAppButton(
                  text: 'Continue',
                  onPressed: () {
                    if (context
                        .read<SignUpCubit>()
                        .signUpFormKey
                        .currentState!
                        .validate()) {
                      context.pushReplacementNamed(Routes.enterNameScreen);
                    }
                  },
                ),
                verticalSpacing(16),
                AlreadyHaveAnAccountOrCreateAccount(
                  title: 'Already have an account',
                  navigationText: 'Log in',
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

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().signUpFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'Email address',
            obscureText: false,
            controller: context.read<SignUpCubit>().emailController,
          ),
          verticalSpacing(24),
          CustomTextFormField(
            hintText: 'Password',
            obscureText: false,
            controller: context.read<SignUpCubit>().passwordController,
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
        ],
      ),
    );
  }
}
