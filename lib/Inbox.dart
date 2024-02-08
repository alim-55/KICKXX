import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ChatPage.dart';

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
      body:
      Container(

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.deepPurple,
                Colors.black,
                Colors.deepPurple,
                Colors.black,
                Colors.deepPurple,
                Colors.black
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InboxCollection()),
    );
  }
}

class InboxCollection extends StatelessWidget {
  const InboxCollection({Key? key});

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
        } else {
          List<String> items =
          snapshot.data!.docs.map((doc) => doc.id).toList();
          if (items.isEmpty) {
            return const Center(
              child: Text('No items found in the collection.'),
            );
          } else {
            return ListView(
              children: [
                for (String receiver in items)
                  InboxCard(receiverEmail: receiver),
              ],
            );
          }
        }
      },
    );
  }
}

class InboxCard extends StatelessWidget {
  final String receiverEmail;
  InboxCard({Key? key, required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Increased padding here
      child: Card(
        elevation: 4,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(receiverEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
              final userEmail = userData['Email'];

              if (userEmail != currentUserEmail) {
                return ListTile(
                  title: Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverUserEmail: userEmail,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.deepPurple,
                    backgroundImage: _selectedImage(userData['profilePicture']),
                  ),
                );
              }
            }

            return SizedBox.shrink(); // Exclude the current user from the list
          },
        ),
      ),
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
