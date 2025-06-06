import 'package:chatgpt/feature/home/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Save or update a chat
  Future<void> saveChat(ChatModel chat) async {
    if (_userId == null) {
      log('ChatRepository: No user logged in');
      return;
    }

    try {
      log('ChatRepository: Saving chat with ${chat.messages.length} messages');

      // Convert to JSON manually to ensure proper serialization
      final chatData = {
        'id': chat.id,
        'title': chat.title,
        'messages': chat.messages.map((msg) => msg.toJson()).toList(),
        'createdAt': chat.createdAt.millisecondsSinceEpoch,
        'updatedAt': chat.updatedAt.millisecondsSinceEpoch,
      };

      log('ChatRepository: Chat data to save: $chatData');

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('chats')
          .doc(chat.id)
          .set(chatData);

      log('ChatRepository: Chat saved successfully');
    } catch (e) {
      log('ChatRepository: Error saving chat: $e');
      rethrow;
    }
  }

  // Get all chats for current user
  Future<List<ChatModel>> getUserChats() async {
    if (_userId == null) {
      log('ChatRepository: No user logged in');
      return [];
    }

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('chats')
              .orderBy('updatedAt', descending: true)
              .get();

      log('ChatRepository: Retrieved ${snapshot.docs.length} chats');

      return snapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              log('ChatRepository: Processing chat data: $data');
              return ChatModel.fromJson(data);
            } catch (e) {
              log('ChatRepository: Error parsing chat ${doc.id}: $e');
              // Skip invalid chats instead of crashing
              return null;
            }
          })
          .whereType<ChatModel>()
          .toList(); // Filter out null values
    } catch (e) {
      log('ChatRepository: Error getting user chats: $e');
      return []; // Return empty list instead of throwing
    }
  }

  // Get a specific chat
  Future<ChatModel?> getChat(String chatId) async {
    if (_userId == null) return null;

    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('chats')
              .doc(chatId)
              .get();

      if (doc.exists && doc.data() != null) {
        return ChatModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      log('ChatRepository: Error getting chat $chatId: $e');
      return null;
    }
  }

  // Delete a chat
  Future<void> deleteChat(String chatId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('chats')
        .doc(chatId)
        .delete();
  }

  Future<void> deleteAllChats() async {
    if (_userId == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('chats')
            .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
