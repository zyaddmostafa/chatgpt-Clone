import 'dart:developer';

import 'package:chatgpt/core/utils/api_constatns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds user data to Firestore.
  Future<void> addUserData(User? user, Map<String, dynamic> userData) async {
    if (user?.uid == null) {
      throw Exception("User is not authenticated");
    }

    // First check if email already exists
    final email = userData['email'] as String?;
    if (email == null) {
      throw Exception("Email is required in user data");
    }

    final querySnapshot =
        await firestore
            .collection(ApiConstants.userCollection)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Email already exists
      throw Exception("User with this email already exists");
    }

    // Email doesn't exist, proceed with adding data
    await firestore.collection(ApiConstants.userCollection).add(userData);
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
}
