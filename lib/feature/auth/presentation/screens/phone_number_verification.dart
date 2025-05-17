import 'dart:developer';

import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({super.key});

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
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
              PhoneNumberVerificationForm(),
              verticalSpacing(24),
              CustomAppButton(
                text: 'Send Code',
                onPressed: () {
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
                        context
                            .read<SignUpCubit>()
                            .phoneNumberController
                            .text
                            .trim();

                    // Verify phone number
                    context.read<SignUpCubit>().verifyPhoneNumber();

                    // Navigate to enter code screen
                    context.pushReplacementNamed(Routes.enterCodeScreen);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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

// Model for country data
class Country {
  final String name;
  final String flag;
  final String dialCode;

  Country({required this.name, required this.flag, required this.dialCode});
}

// Sample list of countries - you can expand this list
final List<Country> countries = [
  Country(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
  Country(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
  Country(name: 'India', flag: '🇮🇳', dialCode: '+91'),
  Country(name: 'Canada', flag: '🇨🇦', dialCode: '+1'),
  Country(name: 'Australia', flag: '🇦🇺', dialCode: '+61'),
  Country(name: 'Germany', flag: '🇩🇪', dialCode: '+49'),
  Country(name: 'France', flag: '🇫🇷', dialCode: '+33'),
  Country(name: 'Italy', flag: '🇮🇹', dialCode: '+39'),
  Country(name: 'Spain', flag: '🇪🇸', dialCode: '+34'),
  Country(name: 'China', flag: '🇨🇳', dialCode: '+86'),
  Country(name: 'Japan', flag: '🇯🇵', dialCode: '+81'),
  Country(name: 'Brazil', flag: '🇧🇷', dialCode: '+55'),
  Country(name: 'Mexico', flag: '🇲🇽', dialCode: '+52'),
  Country(name: 'Russia', flag: '🇷🇺', dialCode: '+7'),
  Country(name: 'Egypt', flag: '🇪🇬', dialCode: '+20'),
];

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
          ),
        ],
      ),
    );
  }
}
