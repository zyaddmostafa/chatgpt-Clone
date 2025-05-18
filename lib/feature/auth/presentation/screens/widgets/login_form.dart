import 'package:chatgpt/core/utils/app_regex.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().loginFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'Email address',
            obscureText: false,
            controller: context.read<LoginCubit>().emailController,
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
            obscureText: isObscureText,
            controller: context.read<LoginCubit>().passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return SnackBar(content: Text('Please enter your password'));
              }
              if (value.length < 6) {
                return SnackBar(
                  content: Text('Password must be at least 6 characters'),
                );
              }
              if (!AppRegex.isPasswordValid(value)) {
                return SnackBar(
                  content: Text(
                    'Password must contain at least one letter, one number, and one special character',
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
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
