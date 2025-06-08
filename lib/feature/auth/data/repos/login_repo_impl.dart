import 'dart:developer';

import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/core/services/firebase_store_service.dart';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepoImpl {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseStoreService _firebaseStoreService;

  LoginRepoImpl(this._firebaseAuthService, this._firebaseStoreService);

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

  Future<void> signInWithGoogle() async {
    // Let the service handle all exceptions and just pass them through
    UserCredential userCredential =
        await _firebaseAuthService.loginWithGoogle();

    // Save user data to Firestore
    await _saveUserDataToFirestore(userCredential.user!, 'google');
  }

  _saveUserDataToFirestore(
    User user,
    String signUpMethod, // 'email', 'google', etc.
  ) async {
    try {
      String firstName = user.displayName?.split(' ').first ?? '';
      String lastName =
          user.displayName?.split(' ').length == 2
              ? user.displayName!.split(' ')[1]
              : '';

      String datetime = DateTime.now().toIso8601String();
      // Prepare user data
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'firstName': firstName,
        'lastName': lastName,
        'signUpMethod': signUpMethod,
        'createdAt': datetime,
      };

      // Save to Firestore
      await _firebaseStoreService.addUserData(user, userData);
    } catch (e) {
      log('FirebaseAuthService: _saveUserDataToFirestore: $e');
      throw ErrorMessage(message: 'Error saving user data to Firestore: $e');
    }
  }
}
