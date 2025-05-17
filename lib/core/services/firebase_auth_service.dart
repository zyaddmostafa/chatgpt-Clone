import 'dart:developer';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';
import 'package:chatgpt/feature/auth/data/models/sign_up_request_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  // firebase signup
  Future<User> signUpWithEmailAndPassword({
    required SignUpRequestBody signUpRequestBody,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: signUpRequestBody.email,
        password: signUpRequestBody.password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'FirebaseAuthService: signUpWithEmailAndPassword: ${e.code} - ${e.message}',
      );
      switch (e.code) {
        case 'weak-password':
          throw const ErrorMessage(
            message: 'The password provided is too weak.',
          );
        case 'email-already-in-use':
          throw const ErrorMessage(
            message: 'The account already exists for that email.',
          );
        case 'invalid-email':
          throw const ErrorMessage(message: 'Invalid email address.');
        case 'operation-not-allowed':
          throw const ErrorMessage(
            message: 'Email/password sign-up is not enabled.',
          );
        case 'network-request-failed':
          throw const ErrorMessage(
            message: 'A network error occurred. Please check your connection.',
          );
        case 'too-many-requests':
          throw const ErrorMessage(
            message: 'Too many requests. Please try again later.',
          );
        case 'admin-restricted-operation':
          throw const ErrorMessage(
            message: 'This operation is restricted to administrators only.',
          );
        case 'invalid-credential':
          throw const ErrorMessage(
            message: 'The credential data is malformed or has expired.',
          );
        default:
          throw ErrorMessage(
            message: 'Sign-up error: ${e.message ?? "Something went wrong."}',
          );
      }
    } catch (e) {
      log(
        'FirebaseAuthService: signUpWithEmailAndPassword: General exception: $e',
      );
      throw const ErrorMessage(message: 'Something went wrong!');
    }
  }

  // firebase login
  Future<void> loginWithEmailAndPassword(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: loginRequestBody.email,
        password: loginRequestBody.password,
      );
    } on FirebaseAuthException catch (e) {
      log('Firebase login error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          throw const ErrorMessage(message: 'No user found for that email.');
        case 'wrong-password':
          throw const ErrorMessage(
            message: 'Wrong password provided for that user.',
          );
        case 'invalid-email':
          throw const ErrorMessage(message: 'Invalid email address.');
        case 'user-disabled':
          throw const ErrorMessage(
            message: 'This user account has been disabled.',
          );
        case 'too-many-requests':
          throw const ErrorMessage(
            message: 'Too many login attempts. Please try again later.',
          );
        case 'operation-not-allowed':
          throw const ErrorMessage(
            message: 'Email/password sign-in is not enabled.',
          );
        case 'account-exists-with-different-credential':
          throw const ErrorMessage(
            message:
                'An account already exists with the same email address but different sign-in credentials.',
          );
        case 'invalid-credential':
          throw const ErrorMessage(
            message: 'The credential data is malformed or has expired.',
          );
        case 'network-request-failed':
          throw const ErrorMessage(
            message: 'A network error occurred. Please check your connection.',
          );
        case 'auth/invalid-verification-code':
          throw const ErrorMessage(
            message: 'The verification code is invalid.',
          );
        default:
          throw ErrorMessage(
            message:
                'Authentication error: ${e.message ?? "Something went wrong."}',
          );
      }
    }
  }

  Future<UserCredential> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      // Always save/update user data (merge handles existing users)
      // if (userCredential.user != null) {
      //   await _saveUserDataToFirestore(userCredential.user!, 'google');
      // }

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Future<void> _saveUserDataToFirestore(User user, String provider) async {
  //   try {
  //     await _firestore.collection('users').doc(user.uid).set(
  //       {
  //         'uid': user.uid,
  //         'email': user.email,
  //         'displayName': user.displayName,
  //         'photoURL': user.photoURL,
  //         'createdAt': FieldValue.serverTimestamp(),
  //         'provider': provider,
  //         // Add any other fields you want to store
  //       },
  //       SetOptions(merge: true),
  //     ); // Use merge to avoid overwriting existing data
  //   } catch (e) {
  //     print('Error saving user data: $e');
  //   }
  // }

  // verify phone number
  // Update your verifyPhoneNumber method

  Future<String> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    try {
      String verificationId = '';

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android (when possible)
          log('Auto-verification completed');
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          log('Phone verification failed: ${e.code} - ${e.message}');
          onVerificationFailed(e);
        },
        codeSent: (String verId, int? resendToken) {
          log('Verification code sent to $phoneNumber');
          verificationId = verId;
          onCodeSent(verId);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
        timeout: const Duration(seconds: 60),
        // For web applications, use the following to handle reCAPTCHA
        // recaptchaVerifier: RecaptchaVerifier(
        //   container: 'recaptcha',
        //   size: RecaptchaVerifierSize.compact,
        //   theme: RecaptchaVerifierTheme.light,
        // ),
      );

      return verificationId;
    } catch (e) {
      log('FirebaseAuthService: verifyPhoneNumber: General exception: $e');
      throw ErrorMessage(
        message: 'Something went wrong with phone verification: $e',
      );
    }
  }

  // Verifies the SMS code and signs in the user
  Future<UserCredential> verifyOtpAndSignIn({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with the credential
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthService: verifyOtpAndSignIn: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'invalid-verification-code':
          throw const ErrorMessage(
            message: 'The verification code is invalid. Please try again.',
          );
        case 'invalid-verification-id':
          throw const ErrorMessage(
            message:
                'The verification ID is invalid. Please request a new code.',
          );
        case 'session-expired':
          throw const ErrorMessage(
            message: 'The SMS code has expired. Please request a new code.',
          );
        default:
          throw ErrorMessage(
            message:
                'Verification error: ${e.message ?? "Something went wrong."}',
          );
      }
    } catch (e) {
      log('FirebaseAuthService: verifyOtpAndSignIn: General exception: $e');
      throw const ErrorMessage(
        message: 'Something went wrong during verification!',
      );
    }
  }

  // Check if the user is logged in
  bool isLoggedIn() {
    getCurrentUser();
    return _firebaseAuth.currentUser != null;
  }

  // user sign out
  Future<void> signOut() async => await _firebaseAuth.signOut();

  // user delete
  Future<void> deleteUser() => _firebaseAuth.currentUser!.delete();

  // get current user
  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      log('FirebaseAuthService: getCurrentUser: $e');
      return null;
    }
  }

  // get user id
  String getCurrentUserId() {
    try {
      return _firebaseAuth.currentUser!.uid;
    } catch (e) {
      log('FirebaseAuthService: getUserId: $e');
      return '';
    }
  }
}
