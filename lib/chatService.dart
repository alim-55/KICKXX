import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
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


  Future<File?> getImage() async {
    ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<String?> uploadImage(File imageFile, String chatRoomId) async {
    try {
      String fileName = Uuid().v1();
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;


      String imageUrl = await taskSnapshot.ref.getDownloadURL();


      await _firestore.collection('chatRoom').doc(chatRoomId).collection('messages').doc(fileName).set({
        "senderID": _firebaseAuth.currentUser!.email,
        "message": imageUrl,
        "type": "img",
      });

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}