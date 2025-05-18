import 'package:chatgpt/core/utils/app_regex.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return SnackBar(
                  content: Text('Please enter your email address'),
                );
              }
              if (!AppRegex.isEmailValid(value)) {
                return SnackBar(
                  content: Text('Please enter a valid email address'),
                );
              }
            },
          ),
          verticalSpacing(24),
          CustomTextFormField(
            hintText: 'Password',
            obscureText: false,
            controller: context.read<SignUpCubit>().passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return SnackBar(content: Text('Please enter your password'));
              }
              if (value.length < 6) {
                return SnackBar(
                  content: Text('Password must be at least 8 characters long'),
                );
              }
              if (!AppRegex.isPasswordValid(value)) {
                return SnackBar(
                  content: Text(
                    'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
                  ),
                );
              }
            },
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
