import 'package:chatgpt/feature/auth/presentation/screens/enter_code_screen.dart';
import 'package:chatgpt/feature/auth/presentation/screens/enter_name_screen.dart';
import 'package:chatgpt/feature/auth/presentation/screens/login_screen.dart';
import 'package:chatgpt/feature/auth/presentation/screens/phone_number_verification.dart';
import 'package:chatgpt/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:chatgpt/feature/auth/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt/core/routing/routes.dart';
// Import your screen widgets

class AppRoutes {
  static Route<dynamic> ongenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcomeScreen:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(), // Create this screen
          settings: settings,
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(), // Create this screen
          settings: settings,
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(), // Create this screen
          settings: settings,
        );
      case Routes.enterNameScreen:
        return MaterialPageRoute(
          builder: (_) => const EnterNameScreen(), // Create this screen
          settings: settings,
        );

      case Routes.phoneVerificationScreen:
        return MaterialPageRoute(
          builder: (_) => const PhoneNumberVerification(), // Create this screen
          settings: settings,
        );
      case Routes.enterCodeScreen:
        return MaterialPageRoute(
          builder: (_) => const EnterCodeScreen(), // Create this screen
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
