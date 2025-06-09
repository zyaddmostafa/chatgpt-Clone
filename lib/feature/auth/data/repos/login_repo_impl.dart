import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';

class LoginRepoImpl {
  final FirebaseAuthService _firebaseAuthService;

  LoginRepoImpl(this._firebaseAuthService);

  /// Signs in a user with email and password.

  Future<void> signInWithEmailAndPassword(
    LoginRequestBody loginRequestBody,
  ) async {
    await _firebaseAuthService.loginWithEmailAndPassword(loginRequestBody);
  }

  Future<void> signInWithGoogle() async {
    // Let the service handle all exceptions and just pass them through
    await _firebaseAuthService.loginWithGoogle();
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }
}
