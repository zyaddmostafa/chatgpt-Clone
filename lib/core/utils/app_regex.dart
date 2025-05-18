class AppRegex {
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
  static const String phoneNumberRegex = r'^\+?[1-9]\d{1,14}$';

  // Verification code regex - exactly 6 digits
  static const String verificationCodeRegex = r'^[0-9]{6}$';

  // Validation functions
  static bool isEmailValid(String email) {
    return RegExp(emailRegex).hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(passwordRegex).hasMatch(password);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return RegExp(phoneNumberRegex).hasMatch(phoneNumber);
  }

  static bool isVerificationCodeValid(String code) {
    return RegExp(verificationCodeRegex).hasMatch(code);
  }
}
