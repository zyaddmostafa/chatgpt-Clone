import 'dart:developer';

import 'package:chatgpt/feature/auth/data/models/sign_up_request_body.dart';
import 'package:chatgpt/feature/auth/data/repos/sign_up_repo_impl.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController verificationCodeController =
      TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneVerificationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> enterCodeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> enterNameFormKey = GlobalKey<FormState>();
  String? _verificationId;

  void signUpUsingEmailAndPassword() {
    emit(SignUpLoading());
    try {
      log('email: ${emailController.text}');
      log('password: ${passwordController.text}');
      log('phoneNumber: ${phoneNumberController.text}');
      log('firstName: ${firstNameController.text}');
      log('lastName: ${lastNameController.text}');

      signUpRepoImpl.signUpWithEmailAndPassword(
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
      // add user data to firestore
      saveUserDataToFirestore('signUp with email and password');
      // Clear the controllers after successful sign-up
      emailController.clear();
      passwordController.clear();
      phoneNumberController.clear();
      firstNameController.clear();
      lastNameController.clear();
    } catch (e) {
      // Clear the controllers in case of an error
      emailController.clear();
      passwordController.clear();
      phoneNumberController.clear();
      firstNameController.clear();
      lastNameController.clear();
      emit(SignUpError(e.toString()));
    }
  }

  // Add these methods to your SignUpCubit class

  void verifyPhoneNumber() async {
    emit(SignUpPhoneVerificationLoading());
    try {
      // Format the phone number with country code
      final phoneNumber =
          "${dialCodeController.text}${phoneNumberController.text}";

      signUpRepoImpl.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: (String verificationId) {
          _verificationId = verificationId;
          emit(SignUpPhoneVerificationCodeSent(verificationId));
        },
        onVerificationFailed: (FirebaseAuthException e) {
          emit(
            SignUpPhoneVerificationError(
              e.message ??
                  'Verification failed you might have already verified this number with another account',
            ),
          );
        },
      );
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }

  Future<void> verifyOtpCode(String smsCode) async {
    if (_verificationId == null) {
      emit(
        SignUpPhoneVerificationError(
          'Please request a verification code first',
        ),
      );
      return;
    }

    emit(SignUpPhoneVerificationLoading());
    try {
      signUpRepoImpl.verifyOtpAndSignIn(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      emit(SignUpPhoneVerificationSuccess());
      signUpUsingEmailAndPassword();
      // Clear the controllers after successful verification
    } catch (e) {
      emit(SignUpPhoneVerificationError(e.toString()));
    }
  }

  Future<void> saveUserDataToFirestore(String provider) async {
    emit(AddUserDataToFirestoreLoading());
    try {
      await signUpRepoImpl.saveUserDataToFirestore(
        signUpRequestBody: SignUpRequestBody(
          email: emailController.text,
          password: passwordController.text,
          phoneNumber:
              '${dialCodeController.text}${phoneNumberController.text}',
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          provider: provider,
        ),
      );
      emit(AddUserDataToFirestoreSuccess());
    } catch (e) {
      emit(AddUserDataToFirestoreError(e.toString()));
    }
  }
}

  // add user data to firestore

  
