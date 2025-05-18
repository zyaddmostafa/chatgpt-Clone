import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_state.dart';

import '../../../../core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:chatgpt/core/routing/routes.dart';

class SignUpLoadingScreen extends StatelessWidget {
  const SignUpLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          // Navigate to home screen on success
          context.pushReplacementNamed(Routes.homeScreen);
        } else if (state is SignUpError) {
          // Show error dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => AlertDialog(
                  title: const Text('Login Failed'),
                  content: Text(state.errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Close dialog and navigate to welcome screen
                        Navigator.pop(context);
                        context.pushReplacementNamed(Routes.welcomeScreen);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinning app logo
              _SpinningLogo(),
              verticalSpacing(24),

              // Optional loading text
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpinningLogo extends StatefulWidget {
  const _SpinningLogo();

  @override
  State<_SpinningLogo> createState() => _SpinningLogoState();
}

class _SpinningLogoState extends State<_SpinningLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        Assets.assetsImagesSmallerAppIcon,
        color: Colors.black,
      ),
    );
  }
}
