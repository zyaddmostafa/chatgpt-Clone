import 'package:chatgpt/core/utils/api_constatns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds user data to Firestore.
  Future<void> addUserData(User? user, Map<String, dynamic> userData) async {
    if (user?.uid != null) {
      await firestore
          .collection(ApiConstants.userCollection)
          .doc(user?.uid)
          .set(userData, SetOptions(merge: true));
    } else {
      await firestore.collection(ApiConstants.userCollection).add(userData);
    }
  }
}
