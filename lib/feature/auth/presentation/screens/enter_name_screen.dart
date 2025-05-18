import 'dart:developer';

import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/enter_name_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterNameScreen extends StatelessWidget {
  const EnterNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AuthHeader(title: 'Tell us About You'),
              verticalSpacing(24),
              EnterNameForm(),
              verticalSpacing(24),
              CustomAppButton(
                text: 'Continue',
                onPressed: () {
                  if (context
                      .read<SignUpCubit>()
                      .enterNameFormKey
                      .currentState!
                      .validate()) {
                    log(
                      'email: ${context.read<SignUpCubit>().emailController.text}',
                    );
                    log(
                      'password: ${context.read<SignUpCubit>().passwordController.text}',
                    );
                    log(
                      'firstName: ${context.read<SignUpCubit>().firstNameController.text}',
                    );
                    log(
                      'lastName: ${context.read<SignUpCubit>().lastNameController.text}',
                    );
                    context.pushReplacementNamed(
                      Routes.phoneVerificationScreen,
                    );
                  }
                },
              ),
              verticalSpacing(16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'By clicking "Continue" you agree to our ',
                      style: TextStyle(
                        color: const Color(0xFF5E6064),
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                    TextSpan(
                      text: 'Terms \n',
                      style: TextStyle(
                        color: const Color(0xFF4AA181),
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                    TextSpan(
                      text: "and confirm you're 18 years or older.",
                      style: TextStyle(
                        color: const Color(0xFF5E6064),
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
