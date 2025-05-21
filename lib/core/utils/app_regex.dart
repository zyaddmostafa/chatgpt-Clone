class AppRegex {
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$';
  static const String phoneNumberRegex = r'^\+\d{1,3}\d{6,10}$';

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

  // Keep your existing regex patterns and validation methods

  // Method to handle Firebase Auth error codes
  static String getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials.';
      case 'invalid-credential':
        return 'The email or password is incorrect. Please try again.';
      case 'network-request-failed':
        return 'A network error occurred. Please check your connection.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again.';
      case 'user-token-expired':
        return 'Your session has expired. Please log in again.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid. Please request a new code.';
      case 'session-expired':
        return 'The SMS code has expired. Please request a new code.';
      default:
        return 'Authentication error: $errorCode. Please try again.';
    }
  }

  // Add these specific OTP error codes to your existing getFirebaseAuthErrorMessage method in AppRegex.dart
  static String getOTPErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-verification-code':
        return 'The verification code is invalid. Please try again.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid. Please request a new code.';
      case 'session-expired':
        return 'The SMS code has expired. Please request a new code.';
      case 'code-expired':
        return 'The verification code has expired. Please request a new code.';
      case 'missing-verification-code':
        return 'Please enter the verification code.';
      case 'missing-verification-id':
        return 'Verification process was not properly initiated. Please try again.';
      case 'credential-already-in-use':
        return 'This phone number is already linked to another account.';
      case 'quota-exceeded':
        return 'SMS quota has been exceeded. Please try again tomorrow.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Verification error: $errorCode. Please try again.';
    }
  }
}
