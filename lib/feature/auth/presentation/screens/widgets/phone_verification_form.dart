import 'package:chatgpt/core/utils/app_regex.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberVerificationForm extends StatelessWidget {
  const PhoneNumberVerificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().phoneVerificationFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'Phone Number',
            controller: context.read<SignUpCubit>().phoneNumberController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return SnackBar(
                  content: Text('Please enter your phone number'),
                );
              }
              if (!AppRegex.isPhoneNumberValid(value)) {
                return SnackBar(
                  content: Text('Please enter a valid phone number'),
                );
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
