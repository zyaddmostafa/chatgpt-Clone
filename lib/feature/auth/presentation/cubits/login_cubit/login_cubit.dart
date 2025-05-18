import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';
import 'package:chatgpt/feature/auth/data/repos/login_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final LoginRepoImpl loginRepoImpl;
  LoginCubit(this.loginRepoImpl) : super(LoginInitial());

  Future<void> loginUsingEmailAndPassword() async {
    emit(LoginLoading());
    try {
      await loginRepoImpl.signInWithEmailAndPassword(
        LoginRequestBody(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
      emit(LoginSuccess());
      // Clear the controllers after successful login
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      // Clear the controllers in case of an error
      emailController.clear();
      passwordController.clear();
      emit(LoginError(e.toString()));
    }
  }
}
