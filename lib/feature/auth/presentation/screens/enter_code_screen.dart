import 'dart:developer';

import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AuthHeader(title: 'Enter Code'),
              verticalSpacing(16),
              Text(
                'Please enter the code we just sent you',
                style: AppTextstyles.font14Regular,
              ),
              verticalSpacing(24),
              Form(
                key: context.read<SignUpCubit>().enterCodeFormKey,
                child: CustomTextFormField(
                  hintText: '000000',
                  controller:
                      context.read<SignUpCubit>().verificationCodeController,
                  keyboardType: TextInputType.number,
                  contentPadding: EdgeInsets.symmetric(horizontal: 145),
                ),
              ),
              verticalSpacing(16),

              BlocListener<SignUpCubit, SignUpState>(
                listenWhen:
                    (previous, current) =>
                        current is SignUpPhoneVerificationLoading,
                listener: (context, state) {
                  context.pushReplacementNamed(Routes.signUpLoadingScreen);
                },
                child: CustomAppButton(
                  text: 'Verify',
                  onPressed: () {
                    _codeVerificationValidation(context);
                  },
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Resend Code', style: AppTextstyles.font14Regular),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _codeVerificationValidation(BuildContext context) {
    if (context.read<SignUpCubit>().enterCodeFormKey.currentState!.validate()) {
      log(
        'Verification code:  ${context.read<SignUpCubit>().verificationCodeController.text}',
      );
      context.read<SignUpCubit>().verifyOtpCode(
        context.read<SignUpCubit>().verificationCodeController.text,
      );
    }
  }
}
