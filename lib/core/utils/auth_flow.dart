import 'package:chatgpt/feature/auth/presentation/screens/enter_code_screen.dart';
import 'package:chatgpt/feature/auth/presentation/screens/enter_name_screen.dart';
import 'package:chatgpt/feature/auth/presentation/screens/phone_number_verification.dart';
import 'package:chatgpt/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt/core/routing/routes.dart';
// Import your screens

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: Routes.signupScreen,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.signupScreen:
            return MaterialPageRoute(builder: (_) => const SignUpScreen());
          case Routes.enterNameScreen:
            return MaterialPageRoute(builder: (_) => const EnterNameScreen());
          case Routes.phoneVerificationScreen:
            return MaterialPageRoute(
              builder: (_) => const PhoneNumberVerification(),
            );
          case Routes.enterCodeScreen:
            return MaterialPageRoute(builder: (_) => const EnterCodeScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SignUpScreen());
        }
      },
    );
  }
}
