import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/core/widgets/auth_header.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E6EB)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(selectedCountry.flag),
                      const SizedBox(width: 8),
                      Text(selectedCountry.dialCode),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
              ),

              verticalSpacing(12),
              CustomTextFormField(
                hintText: 'Phone Number',
                onTap: () {},
                keyboardType: TextInputType.phone,
              ),
              verticalSpacing(24),
              CustomAppButton(
                text: 'Send Code',
                onPressed: () {
                  context.pushReplacementNamed(Routes.enterCodeScreen);
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
          width: double.infinity,
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
