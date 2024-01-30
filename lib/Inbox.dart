import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/ChatPage.dart';

class Inbox extends StatelessWidget {
  const Inbox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Inbox",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: inboxCollection(),
    );
  }
}

class inboxCollection extends StatelessWidget {
  const inboxCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('inbox')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<String> items = snapshot.data!.docs.map((doc) => doc.id).toList();
        if (items.isEmpty) {
          return const Center(
            child: Text('No items found in the collection.'),
          );
        } else {
          return ListView(
            children: [
              for (String receiver in items) InboxCard(receiverEmail: receiver),
            ],
          );
        }
      },
    );
  }
}

class InboxCard extends StatelessWidget {
  String receiverEmail;
  InboxCard({super.key, required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(receiverEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserEmail: receiverEmail,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: _selectedImage(userData['profilePicture']),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(userData['Email']),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error${snapshot.error}"),
              );
            } else
              return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
ImageProvider<Object>? _selectedImage(String? imagePath) {
  if (imagePath != null && imagePath.isNotEmpty) {
    return NetworkImage(imagePath);
  } else {
    return AssetImage("assets/prof_bg3.png");
  }
}
