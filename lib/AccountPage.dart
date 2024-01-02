

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:kickxx/signin_screen.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import 'text_box.dart';
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

 final currentUser =FirebaseAuth.instance.currentUser!;

 final userCollection= FirebaseFirestore.instance.collection("users");
 Future<void>editField(String field)async {
   String newValue ="";
   await showDialog(context: context,
     builder: (context)=>AlertDialog(
       backgroundColor: Colors.grey,
     title: Text("Edit $field",
       style: TextStyle(color: Colors.white),
     ),
     content: TextField(
       autofocus: true,
       style: TextStyle(color: Colors.black),
       decoration: InputDecoration(
         hintText: "Enter new $field",
         hintStyle: TextStyle(color: Colors.grey),
       ),
       onChanged: (value){
         newValue=value;
       },
     ),
     actions: [
       TextButton(
         child:Text( "Cancel",style: TextStyle(color: Colors.black),),
       onPressed: ()=>Navigator.pop(context),),

       TextButton(
         child:Text( "Save",style: TextStyle(color: Colors.black),),
         onPressed: ()=>Navigator.of(context).pop(newValue),),
     ],
   ),

   );

   //Update n firestore

   if(newValue.length>0){
     await userCollection.doc(currentUser.email).update({field:newValue});
   }

 }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Container(
        decoration: BoxDecoration(
          //gradient: LinearGradient(colors: [Colors.black,Colors.deepPurple,Colors.black,Colors.deepPurple,Colors.black,Colors.deepPurple,Colors.black],
              //[Colors.black, Colors.black, Colors.black],
              //[Color(0xFF0F52BA), Color(0xFFC0C0C0)],
             // begin: Alignment.topLeft, end: Alignment.bottomRight),
          color: Colors.grey
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData && snapshot.data!.data() != null){
              final userData= snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  SizedBox(height: 50),

                  Icon(
                    Icons.person_outline,size: 72,
                    color: Colors.black,
                  ),

                  SizedBox(height: 10),

                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,
                      fontSize: 20),
                  ),
                  SizedBox(height: 50),

                  Padding(
                      padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Details",
                    style: TextStyle(color: Colors.black,
                      fontSize: 20
                    ),
                  ),
                  ),

                  TextBox(
                    text:userData["User name"],
                    sectionName: 'Username',
                    onPressed: ()=>editField('User name'),
                  ),

                  SizedBox(height: 10),

                  TextBox(
                    text:userData["Phone"],
                    sectionName: 'Phone',
                    onPressed: ()=>editField('Phone'),
                  ),
                  SizedBox(height: 10),

                  firebaseButton(context, "Logout", (){
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>SignInScreen()));
                  }),
                ],
              );
            } else if(snapshot.hasError){
              return Center(
                child: Text("Error${snapshot.error}"),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

