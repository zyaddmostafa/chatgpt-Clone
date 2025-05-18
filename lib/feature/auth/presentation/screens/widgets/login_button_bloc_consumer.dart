import 'package:chatgpt/core/routing/routes.dart' show Routes;
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/widgets/custom_app_button.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginButtonBlocConsumer extends StatelessWidget {
  const LoginButtonBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => current is LoginLoading,
      listener: (context, state) {
        // Show loading indicator
        context.pushReplacementNamed(Routes.loginLoadingScreen);
      },
      child: CustomAppButton(
        text: 'Continue',
        onPressed: () {
          _loginValidation(context);
        },
      ),
    );
  }
}

void _loginValidation(BuildContext context) {
  if (context.read<LoginCubit>().loginFormKey.currentState!.validate()) {
    context.read<LoginCubit>().loginUsingEmailAndPassword();
  }
}
