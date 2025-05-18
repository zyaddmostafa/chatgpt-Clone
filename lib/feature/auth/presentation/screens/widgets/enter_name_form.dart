import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterNameForm extends StatelessWidget {
  const EnterNameForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().enterNameFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'First Name',
            controller: context.read<SignUpCubit>().firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return SnackBar(content: Text('Please enter your first name'));
              }
              return null;
            },
          ),
          verticalSpacing(24),
          CustomTextFormField(
            hintText: 'Last Name',
            controller: context.read<SignUpCubit>().lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return SnackBar(content: Text('Please enter your last name'));
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
