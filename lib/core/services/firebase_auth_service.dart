import 'dart:developer';
import 'package:chatgpt/core/utils/app_regex.dart';
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
      throw ErrorMessage(message: AppRegex.getFirebaseAuthErrorMessage(e.code));
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
      throw ErrorMessage(message: AppRegex.getFirebaseAuthErrorMessage(e.code));
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
      throw ErrorMessage(message: AppRegex.getFirebaseAuthErrorMessage(e.code));
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
