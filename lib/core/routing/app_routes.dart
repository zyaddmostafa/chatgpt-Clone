import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case Routes.welocmeScreen:
        MaterialPageRoute(builder: (context) => const WelcomeScreen());
      default:
        return null;
    }
  }
}
