import 'package:flutter/material.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {}

final class SignUpError extends SignUpState {
  final String errorMessage;
  SignUpError(this.errorMessage);
}

class SignUpPhoneVerificationCodeSent extends SignUpState {
  final String verificationId;

  SignUpPhoneVerificationCodeSent(this.verificationId);
}

final class SignUpPhoneVerificationCodeSentLoading extends SignUpState {}

final class SignUpPhoneVerificationCodeSentError extends SignUpState {
  final String errorMessage;
  SignUpPhoneVerificationCodeSentError(this.errorMessage);
}

final class SignUpPhoneVerificationLoading extends SignUpState {}

final class SignUpPhoneVerificationSuccess extends SignUpState {}

final class SignUpPhoneVerificationError extends SignUpState {
  final String errorMessage;
  SignUpPhoneVerificationError(this.errorMessage);
}

final class AddUserDataToFirestoreLoading extends SignUpState {}

final class AddUserDataToFirestoreSuccess extends SignUpState {}

final class AddUserDataToFirestoreError extends SignUpState {
  final String errorMessage;
  AddUserDataToFirestoreError(this.errorMessage);
}
