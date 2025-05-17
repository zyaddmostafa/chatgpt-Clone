import 'dart:developer';

import 'package:chatgpt/feature/auth/data/models/sign_up_request_body.dart';
import 'package:chatgpt/feature/auth/data/repos/sign_up_repo_impl.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepoImpl signUpRepoImpl;
  SignUpCubit(this.signUpRepoImpl) : super(SignUpInitial());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dialCodeController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneVerificationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> enterCodeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> enterNameFormKey = GlobalKey<FormState>();

  Future<void> signUpUsingEmailAndPassword() async {
    emit(SignUpLoading());
    try {
      log('email: ${emailController.text}');
      log('password: ${passwordController.text}');
      log('phoneNumber: ${phoneNumberController.text}');
      log('firstName: ${firstNameController.text}');
      log('lastName: ${lastNameController.text}');

      await signUpRepoImpl.signUpWithEmailAndPassword(
        SignUpRequestBody(
          email: emailController.text,
          password: passwordController.text,
          phoneNumber: phoneNumberController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          provider: 'signUp with email and password',
        ),
      );
      emit(SignUpSuccess());
      emailController.clear();
      passwordController.clear();
      phoneNumberController.clear();
      firstNameController.clear();
      lastNameController.clear();
    } catch (e) {
      emailController.clear();
      passwordController.clear();
      phoneNumberController.clear();
      firstNameController.clear();
      lastNameController.clear();
      emit(SignUpError(e.toString()));
    }
  }
}
