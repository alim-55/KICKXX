import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple,
      ),
      child: Text('message',style: TextStyle(fontSize: 15,color: Colors.white),),
    );
  }
}
