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
        title: Text(
          "Inbox",
          style: TextStyle(color: Colors.white),
        ),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<String> items =
        snapshot.data!.docs.map((doc) => doc.id).toList();
        if (items.isEmpty) {
          return Center(
            child: Text('No items found in the collection.'),
          );
        } else {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: InboxCard(receiverEmail: items[index]),
              );
            },
          );
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: InkWell(
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
          child: Padding(
            padding: EdgeInsets.all(16),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(receiverEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  final userData =
                  snapshot.data!.data() as Map<String, dynamic>;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage:
                        _selectedImage(userData['profilePicture']),
                      ),
                      SizedBox(width: 10),
                      Text(
                        userData['User name'],
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error${snapshot.error}"),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
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
