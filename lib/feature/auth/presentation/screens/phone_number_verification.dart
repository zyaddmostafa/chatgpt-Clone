import 'dart:developer';

import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/snack_bar.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/feature/auth/data/models/country_model.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_state.dart';
import 'package:chatgpt/feature/auth/presentation/screens/widgets/phone_verification_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  // Default country - you can change this to your preferred default
  Country selectedCountry = countries.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AuthHeader(title: 'Phone Number Verification'),
              verticalSpacing(24),

              // Country code selector
              GestureDetector(
                onTap: _showCountryPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E6EB)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedCountry.flag,
                        style: const TextStyle(fontSize: 20),
                      ),
                      horizontalSpacing(8),
                      Text(
                        selectedCountry.dialCode,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      const Icon(Icons.arrow_drop_down_outlined, size: 20),
                    ],
                  ),
                ),
              ),

              verticalSpacing(12),
              PhoneNumberVerificationForm(dialCode: selectedCountry.dialCode),
              verticalSpacing(24),
              CustomAppButton(
                text: 'Send Code',
                onPressed: () {
                  _phoneNumberValidation(context);
                },
              ),
              PhoneVerficationScreenBlocListener(),
            ],
          ),
        ),
      ),
    );
  }

  void _phoneNumberValidation(BuildContext context) {
    if (context
        .read<SignUpCubit>()
        .phoneVerificationFormKey
        .currentState!
        .validate()) {
      // Set the dial code from selected country
      context.read<SignUpCubit>().dialCodeController.text =
          selectedCountry.dialCode;

      // Format the phone number properly (remove spaces, ensure + sign)
      final phoneNumber =
          "${selectedCountry.dialCode}${context.read<SignUpCubit>().phoneNumberController.text.trim()}";

      log('Verifying phone number: $phoneNumber');

      // Update your cubit to store the formatted phone number
      context.read<SignUpCubit>().phoneNumberController.text =
          context.read<SignUpCubit>().phoneNumberController.text.trim();

      // Verify phone number
      context.read<SignUpCubit>().verifyPhoneNumber();

      // Navigate to enter code screen
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Country',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      leading: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(country.name),
                      subtitle: Text(country.dialCode),
                      onTap: () {
                        setState(() {
                          selectedCountry = country;
                        });
                        log(
                          'Selected country: ${country.name} (${country.dialCode})',
                        );

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PhoneVerficationScreenBlocListener extends StatelessWidget {
  const PhoneVerficationScreenBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen:
          (previous, current) =>
              current is SignUpPhoneVerificationLoading ||
              current is SignUpPhoneVerificationSuccess ||
              current is SignUpPhoneVerificationError,

      listener: (context, state) {
        if (state is SignUpPhoneVerificationError) {
          // Show error message
          AppSnackBar.showError(
            context: context,
            message: '${state.errorMessage} or use another number',
            duration: const Duration(seconds: 3),
          );
          Future.delayed(const Duration(seconds: 4), () {
            context.pushReplacementNamed(Routes.loginScreen);
          });
        } else if (state is SignUpPhoneVerificationSuccess) {
          // Navigate to enter code screen
          context.pushReplacementNamed(Routes.enterCodeScreen);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
