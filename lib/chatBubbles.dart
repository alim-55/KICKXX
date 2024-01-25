import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple,
      ),
      child: Text(message, style: TextStyle(fontSize: 15, color: Colors.white)),
    );
  }
}
