import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({super.key});

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
              CustomTextFormField(
                hintText: '000000',
                onTap: () {},
                keyboardType: TextInputType.number,
                contentPadding: EdgeInsets.symmetric(horizontal: 150),
              ),
              verticalSpacing(16),
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
}
