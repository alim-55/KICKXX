

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:kickxx/signin_screen.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import 'signup_screen.dart';
import 'text_box.dart';
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

 final currentUser =FirebaseAuth.instance.currentUser!;
 final _imagePicker = ImagePicker();
 final userCollection= FirebaseFirestore.instance.collection("users");

 //UPDATE USER DETAILS**********
 Future<void>editField(String field)async {
   String newValue ="";
   await showDialog(context: context,
     builder: (context)=>AlertDialog(
       backgroundColor: Colors.deepPurple[200],
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

 //CHANGEPROFILEPICTURE*********

 Future<void> changeProfilePhoto() async {
   final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

   if (pickedFile != null) {
     final storageRef = FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
     await storageRef.putFile(File(pickedFile.path));

     final downloadURL = await storageRef.getDownloadURL();

     // Update the profile picture URL in Firestore
     await userCollection.doc(currentUser.email).update({'profilePicture': downloadURL});
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
          color: Colors.deepPurple[200]
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData && snapshot.data!.data() != null){
              final userData= snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  SizedBox(height: 50),

                  Center(
                    child: Stack(children: <Widget>[
                      CircleAvatar(
                        radius: 72,
                        backgroundImage: _selectedImage(userData['profilePicture']),

                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: GestureDetector(onTap: changeProfilePhoto,
                          child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              child:  Icon(Icons.edit,
                                color: Colors.grey,

                              )),
                          //   if (_selectedImage != null) Image.file(_selectedImage!),
                        ),),],),

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
 ImageProvider<Object>? _selectedImage(String? imagePath) {
   if (imagePath != null && imagePath.isNotEmpty) {
     return NetworkImage(imagePath);
   } else {
     // If no profile picture is available, you can use a placeholder or default image.
     return AssetImage("assets/default_profile_image.png");
   }
 }

}

