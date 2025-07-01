import 'dart:developer';

import 'package:chatgpt/core/utils/api_constatns.dart';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds user data to Firestore.
  Future<void> addUserData(User? user, Map<String, dynamic> userData) async {
    if (user?.uid == null) {
      throw ErrorMessage(message: "User is not authenticated");
    }

    // First check if email already exists
    final email = userData['email'] as String?;
    if (email == null) {
      throw ErrorMessage(message: "Email is required in user data");
    }

    final querySnapshot =
        await firestore
            .collection(ApiConstants.userCollection)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Email already exists
      throw ErrorMessage(message: "User with this email already exists");
    }

    // Email doesn't exist, proceed with adding data
    await firestore
        .collection(ApiConstants.userCollection)
        .doc(user!.uid)
        .set(userData, SetOptions(merge: true));
  }

  /// Check if a phone number is already verified in the system
  Future<bool> isPhoneNumberVerified(String phoneNumber) async {
    try {
      // Normalize the phone number to ensure consistent lookup
      String normalizedPhone = normalizePhoneNumber(phoneNumber);

      // Query Firestore for the phone number
      QuerySnapshot querySnapshot =
          await firestore
              .collection(ApiConstants.userCollection)
              .where('phoneNumber', isEqualTo: normalizedPhone)
              .limit(1)
              .get();

      // Return true if any documents found (phone exists), false otherwise
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log('Error checking phone verification status: $e');

      // In case of error, return false to allow verification to proceed
      return false;
    }
  }

  /// Helper method to normalize phone numbers for consistent comparison
  String normalizePhoneNumber(String phoneNumber) {
    // Remove spaces, dashes, or other formatting characters
    String normalized = phoneNumber.replaceAll(RegExp(r'\s+|-|\(|\)'), '');

    // Ensure it starts with + if it doesn't already
    if (!normalized.startsWith('+')) {
      normalized = '+$normalized';
    }

    return normalized;
  }

  /// Get user data from Firestore using email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      if (email.trim().isEmpty) {
        throw ErrorMessage(message: "Email cannot be empty");
      }

      final querySnapshot =
          await firestore
              .collection(ApiConstants.userCollection)
              .where('email', isEqualTo: email.trim().toLowerCase())
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the user data along with document ID
        final doc = querySnapshot.docs.first;
        final userData = doc.data();
        userData['docId'] = doc.id; // Include document ID for future operations
        return userData;
      }

      return null; // User not found
    } catch (e) {
      log('Error getting user by email: $e');
      return null;
    }
  }

  /// Get current authenticated user data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.email == null) {
        log('No authenticated user found');
        return null;
      }

      return await getUserByEmail(currentUser!.email!);
    } catch (e) {
      log('Error getting current user data: $e');
      return null;
    }
  }
}
