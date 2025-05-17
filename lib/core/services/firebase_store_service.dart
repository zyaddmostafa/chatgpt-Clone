// import 'dart:developer';

// import 'package:clot_app/core/apis_helpers/api_constants.dart';
// import 'package:clot_app/features/cart/data/model/cart_product_request_model.dart';
// import 'package:clot_app/features/checkout/data/models/checkout_request_model.dart';
// import 'package:clot_app/features/home/data/model/category_response_model.dart';
// import 'package:clot_app/features/home/data/model/product_response_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseStoreService {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   /// Adds user data to Firestore.
//   Future<void> addUserData(String userId, Map<String, dynamic> userData) async {
//     if (userId.isEmpty) {
//       await firestore
//           .collection(ApiConstants.userCollection)
//           .doc(userId)
//           .set(userData);
//     } else {
//       await firestore.collection(ApiConstants.userCollection).add(userData);
//     }
//   }

//   // Featch Categories from Firestore
//   Future<CategoryResponseModel> getCategories() async {
//     QuerySnapshot snapshot =
//         await firestore.collection(ApiConstants.categoriesCollection).get();
//     // the result is a list of documents form the collection
//     // and we need to convert it to a list of CategoryItem objects first
//     // and then we will return the CategoryResponseModel object
//     final result =
//         snapshot.docs.map((doc) {
//           return CategoryItem.fromJson(doc.data() as Map<String, dynamic>);
//         }).toList();
//     return CategoryResponseModel(categories: result);
//   }

//   Future<ProductResponseModel> getProduct() async {
//     QuerySnapshot snapshot =
//         await firestore.collection(ApiConstants.topSellingCollection).get();
//     // the result is a list of documents form the collection
//     // and we need to convert it to a list of ProductModel objects first
//     // and then we will return the ProductResponseModel object
//     final result =
//         snapshot.docs.map((doc) {
//           return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
//         }).toList();
//     return ProductResponseModel(products: result);
//   }

//   Future<void> addToCart(CartProductRequestModel addToCartModel) async {
//     var userId = FirebaseAuth.instance.currentUser;
//     log('user id: ${userId?.uid} ${userId?.email} ${userId?.displayName} ');
//     await firestore
//         .collection(ApiConstants.userCollection)
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection(ApiConstants.cartCollection)
//         .add(addToCartModel.toJson());
//   }

//   Future<void> removeFromCart(String cartId) async {
//     await firestore
//         .collection(ApiConstants.userCollection)
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection(ApiConstants.cartCollection)
//         .doc(cartId)
//         .delete();
//   }

//   Future<void> updateCartItem(String cartId, Map<String, dynamic> data) async {
//     await firestore
//         .collection(ApiConstants.userCollection)
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection(ApiConstants.cartCollection)
//         .doc(cartId)
//         .update(data);
//   }

//   Future<void> clearCart() async {
//     var userId = FirebaseAuth.instance.currentUser;
//     var cartCollection = firestore
//         .collection(ApiConstants.userCollection)
//         .doc(userId?.uid)
//         .collection(ApiConstants.cartCollection);
//     var snapshot = await cartCollection.get();
//     for (var doc in snapshot.docs) {
//       await doc.reference.delete();
//     }
//   }

//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
//   getCartItems() async {
//     var userId = FirebaseAuth.instance.currentUser;
//     var cartCollection = firestore
//         .collection(ApiConstants.userCollection)
//         .doc(userId?.uid)
//         .collection(ApiConstants.cartCollection);
//     var snapshot = await cartCollection.get();
//     return snapshot.docs;
//   }

//   Future<void> addOrder(CheckoutRequestModel orderData) async {
//     await firestore
//         .collection(ApiConstants.userCollection)
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection(ApiConstants.ordersCollection)
//         .add(orderData.toJson());
//   }

//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
//   getAllOrder() async {
//     var userId = FirebaseAuth.instance.currentUser;
//     var cartCollection = firestore
//         .collection(ApiConstants.userCollection)
//         .doc(userId?.uid)
//         .collection(ApiConstants.ordersCollection);
//     var snapshot = await cartCollection.get();
//     return snapshot.docs;
//   }
// }
