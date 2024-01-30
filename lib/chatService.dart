import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'Message.dart';


class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverEmail, String message) async {
    final String currentUser = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUser,
      senderEmail: currentUserEmail,
      receiverEmail: receiverEmail,
      message: message,
      timestamp: timestamp,
    );

    String chatRoomId = getChatRoomId(currentUserEmail, receiverEmail);
    CollectionReference messagesCollection = _firestore.collection('chatRoom').doc(chatRoomId).collection('messages');
    await messagesCollection.add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String? userEmail, String otherUserEmail) {
    if (userEmail == null) {
      // Handle the case where userEmail is null (provide a default or throw an error)
      throw ArgumentError('userEmail cannot be null');
    }

    String chatRoomId = getChatRoomId(userEmail, otherUserEmail);
    return _firestore
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String getChatRoomId(String userEmail1, String userEmail2) {
    List<String> emails = [userEmail1, userEmail2];
    emails.sort();
    return emails.join("-");
  }

}
