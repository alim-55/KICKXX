import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kickxx/chatPage.dart'; // Import your ChatPage

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _buildChatUserList(),
      ),
    );
  }

  Widget _buildChatUserList() {
    String currentUserEmail = _firebaseAuth.currentUser?.email ?? '';

    return StreamBuilder(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading......');
        }

        List<DocumentSnapshot> users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var userData = users[index].data() as Map<String, dynamic>?;

            // Check if userData is not null
            if (userData != null) {
              String userEmail = userData['email'] ?? '';

              if (userEmail != currentUserEmail) {
                return ListTile(
                  title: Text(userEmail),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(receiverUserEmail: userEmail),
                      ),
                    );
                  },
                );
              }
            }

            return SizedBox.shrink(); // Exclude the current user from the list
          },
        );
      },
    );
  }

}
