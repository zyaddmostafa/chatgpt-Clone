import 'dart:developer';
import 'package:chatgpt/core/di/dependency_injection.dart';
import 'package:chatgpt/core/services/firebase_store_service.dart';
import 'package:chatgpt/core/utils/app_regex.dart';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/auth/data/models/login_request_body.dart';
import 'package:chatgpt/feature/auth/data/models/sign_up_request_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStoreService _firebaseStoreService =
      getIt<FirebaseStoreService>();

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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw const ErrorMessage(message: 'Google sign-in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with the credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      // Save user data to Firestore using the existing store service
      if (userCredential.user != null) {
        await _saveUserDataToFirestore(userCredential.user!, 'google');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Google login error: ${e.code} - ${e.message}');
      throw ErrorMessage(message: AppRegex.getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      log('Google login general error: $e');
      throw ErrorMessage(message: 'Something went wrong with Google sign-in');
    }
  }

  Future<void> _saveUserDataToFirestore(User user, String signUpMethod) async {
    try {
      String firstName = user.displayName?.split(' ').first ?? '';
      String lastName =
          user.displayName?.split(' ').length == 2
              ? user.displayName!.split(' ')[1]
              : '';

      String datetime = DateTime.now().toIso8601String();

      final userData = {
        'uid': user.uid,
        'email': user.email,
        'firstName': firstName,
        'lastName': lastName,
        'signUpMethod': signUpMethod,
        'createdAt': datetime,
      };

      await _firebaseStoreService.addUserData(user, userData);
    } catch (e) {
      log('Error saving user data: $e');
      // Don't throw here, as the main authentication succeeded
      // Just log the error
    }
  }

  // verify phone number
  // Update your verifyPhoneNumber method

  Future<String> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    String verificationId = '';
    try {
      // First check if this phone number is already registered
      bool isPhoneRegistered = await _firebaseStoreService
          .isPhoneNumberVerified(phoneNumber);

      if (isPhoneRegistered) {
        // Phone number already exists in your system
        log('Phone number $phoneNumber is already registered');
        onVerificationFailed(
          FirebaseAuthException(
            code: 'phone-number-already-exists',
            message:
                'This phone number is already registered. Please try logging in instead.',
          ),
        );
        return '';
      }

      // If phone number is not registered, proceed with verification
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

  /// Check if an email is already registered with Firebase Auth

  // Check if the user is logged in
  bool isLoggedIn() {
    getCurrentUser();
    return _firebaseAuth.currentUser != null;
  }

  // user sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      log('FirebaseAuthService: signOut: Error signing out from Google: $e');
    }
  }

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
