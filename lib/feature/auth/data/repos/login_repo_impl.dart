import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepoImpl {
  final FirebaseAuthService _firebaseAuthService;
  LoginRepoImpl(this._firebaseAuthService);

  /// Signs in a user with email and password.

  Future<void> signInWithEmailAndPassword(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      await _firebaseAuthService.loginWithEmailAndPassword(loginRequestBody);
    } on FirebaseAuthException catch (e) {
      throw ErrorMessage(
        message: 'Error signing in with email and password: $e',
      );
    }
  }
}
