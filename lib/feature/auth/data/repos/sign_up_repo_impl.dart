import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/auth/data/models/sign_up_request_body.dart';

class SignUpRepoImpl {
  final FirebaseAuthService _firebaseAuthService;
  SignUpRepoImpl(this._firebaseAuthService);
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
}
