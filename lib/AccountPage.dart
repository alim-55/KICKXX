import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:kickxx/signin_screen.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import 'text_box.dart';
import 'package:kickxx/NotificationPage.dart';
import 'package:kickxx/AccountPage.dart';
import 'package:kickxx/FavoritePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kickxx/HomePage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple[200],
        title: Text(
          "Edit $field",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // Update in firestore
    if (newValue.length > 0) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(color: Colors.white, fontSize: 20),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.black,
              Colors.deepPurple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_outline,
                        size: 72,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "My Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextBox(
                    text: userData["User name"],
                    sectionName: 'Username',
                    onPressed: () => editField('User name'),
                  ),
                  SizedBox(height: 10),
                  TextBox(
                    text: userData["Phone"],
                    sectionName: 'Phone',
                    onPressed: () => editField('Phone'),
                  ),
                  SizedBox(height: 20),
                  firebaseButton(context, "Logout", () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  }),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.error}"),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
