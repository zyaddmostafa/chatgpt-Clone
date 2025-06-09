import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';
import 'package:chatgpt/feature/auth/data/repos/login_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

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

  Future<void> loginUsingGoogle() async {
    emit(LoginLoading());
    try {
      log('Starting Google sign-in process...');
      await loginRepoImpl.signInWithGoogle();
      log('Google sign-in successful');
      emit(LoginSuccess());
    } catch (e) {
      log('Google sign-in failed: $e');
      String errorMessage = e.toString();

      // Provide more specific error messages based on the error
      if (errorMessage.contains('PlatformException(exception, ERROR')) {
        errorMessage =
            'Google Sign-In configuration error. Please check:\n'
            '• Google Services configuration files\n'
            '• SHA-1 fingerprints in Firebase Console\n'
            '• Google Play Services availability';
      } else if (errorMessage.contains('GoogleAuthUtil')) {
        errorMessage =
            'Google authentication service error. Please try again or contact support.';
      }

      emit(LoginError(errorMessage));
    }
  }

  Future<void> logout() async {
    try {
      await loginRepoImpl.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }
}
