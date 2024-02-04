import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/chatBubbles.dart';
import 'package:kickxx/chatService.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        title: Text(widget.receiverUserEmail),
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_rounded),
            color: Colors.white,
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
      stream: _chatService.getMessage(currentUserEmail, widget.receiverUserEmail),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading......');
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser?.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    String senderId = data['senderId'];
    String senderName = data['senderName'] ?? ''; // Assuming senderName is stored in the document

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            senderName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: (data['senderId'] == _firebaseAuth.currentUser?.uid)
                  ? Colors.deepPurple
                  : Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['message'],
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTimestamp(data['timestamp']),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}:${dateTime.year}-${dateTime.hour}:${dateTime.minute}';
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                suffixStyle: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                contentPadding: EdgeInsets.all(15),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .collection("inbox")
                  .doc(widget.receiverUserEmail)
                  .set({});
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.receiverUserEmail)
                  .collection("inbox")
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .set({});
            },
            icon: Icon(Icons.send, size: 40, color: Colors.deepPurple),
          )
        ],
      ),
    );
  }
}
