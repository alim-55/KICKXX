import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickxx/chatService.dart';
import 'package:kickxx/seller_profile.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;

  const ChatPage({
    Key? key,
    required this.receiverUserEmail,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserEmail, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.receiverUserEmail,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.receiverUserEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                print('User not found');
                return Text('User not found');
              }
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Seller_Profile(
                        sellerData: snapshot.data!,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ),
              );
            },
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String currentUserEmail = _firebaseAuth.currentUser?.email ?? '';
    return StreamBuilder(
      stream:
      _chatService.getMessage(currentUserEmail, widget.receiverUserEmail),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error ${snapshot.error}',
              style: TextStyle(color: Colors.deepPurple),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser?.uid;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isCurrentUser ? Colors.deepPurple : Colors.grey.shade300,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['message'],
              style: TextStyle(
                fontSize: 17,
                color: isCurrentUser ? Colors.white : Colors.deepPurple,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTimestamp(data['timestamp']),
              style: TextStyle(
                fontSize: 12,
                color: isCurrentUser ? Colors.white : Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                contentPadding: EdgeInsets.all(15),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: Icon(Icons.send, size: 30, color: Colors.deepPurple),
          ),
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.image, size: 30, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}
