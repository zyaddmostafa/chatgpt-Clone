import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/core/services/firebase_store_service.dart';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/auth/data/models/sign_up_request_body.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpRepoImpl {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseStoreService _firebaseStoreService;
  SignUpRepoImpl(this._firebaseAuthService, this._firebaseStoreService);
  Future<void> signUpWithEmailAndPassword(
    SignUpRequestBody signUpRequestBody,
  ) async {
    try {
      await _firebaseAuthService.signUpWithEmailAndPassword(
        signUpRequestBody: signUpRequestBody,
      );
    } catch (e) {
      throw ErrorMessage(
        message: 'error signing up with email and password: $e',
      );
    }
  }

  // Add these methods to your SignUpRepoImpl class

  Future<String> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    return await _firebaseAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
    );
  }

  Future<UserCredential> verifyOtpAndSignIn({
    required String verificationId,
    required String smsCode,
  }) async {
    return await _firebaseAuthService.verifyOtpAndSignIn(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  Future<void> saveUserDataToFirestore({
    required SignUpRequestBody signUpRequestBody,
  }) async {
    try {
      await _firebaseStoreService.addUserData(
        await _firebaseAuthService.getCurrentUser(),
        signUpRequestBody.toJson(),
      );
    } catch (e) {
      throw ErrorMessage(message: 'error saving user data to firestore: $e');
    }
  }
}
