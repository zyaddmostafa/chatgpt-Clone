import 'package:chatgpt/core/utils/app_regex.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterCodeForm extends StatelessWidget {
  const EnterCodeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().enterCodeFormKey,
      child: CustomTextFormField(
        hintText: '000000',
        controller: context.read<SignUpCubit>().verificationCodeController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your verification code';
          } else if (!AppRegex.isVerificationCodeValid(value)) {
            return 'Please enter a valid verification code';
          }
          return null;
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 145),
      ),
    );
  }
}
