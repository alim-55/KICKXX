import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/add_product.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:kickxx/seller_profile.dart';
import 'package:kickxx/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import 'signup_screen.dart';
import 'signup_screen.dart';
import 'text_box.dart';
import 'added_items.dart';
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
  Future<void> showProductUploadedAlert(BuildContext context) async {
    return QuickAlert.show(
      context: context,
      confirmBtnColor: Colors.deepPurple,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Product ordered successfully!',
      //duration: Duration(seconds: 2),
    );
  }
}
class _AccountPageState extends State<AccountPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _imagePicker = ImagePicker();
  final userCollection = FirebaseFirestore.instance.collection("users");

  //UPDATE USER DETAILS**********
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

            if(field=="Phone"){
              try{
                if(value.length!=11){
                  Fluttertoast.showToast(msg: 'Phone number must have 11 digits', gravity: ToastGravity.TOP);
                  return;
                }
                newValue = value;
              }catch(error){
                //Fluttertoast.showToast(msg: 'Phone number must have 11 digits', gravity: ToastGravity.TOP);
              }
            }
            else{
              newValue = value;
            }

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

    //Update n firestore

    if (newValue.length > 0) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  //CHANGEPROFILEPICTURE*********

  Future<void> changeProfilePhoto() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      await storageRef.putFile(File(pickedFile.path));

      final downloadURL = await storageRef.getDownloadURL();

      // Update the profile picture URL in Firestore
      await userCollection
          .doc(currentUser.email)
          .update({'profilePicture': downloadURL});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w600,),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple,Colors.black, Colors.deepPurple,Colors.black, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 80,
                          child: CircleAvatar(
                            radius: 77,
                            backgroundColor: Colors.white,
                            backgroundImage: _selectedImage(userData['profilePicture']),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: changeProfilePhoto,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      "My Details",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  TextBox(
                    text: userData["User name"],
                    sectionName: 'Username',
                    iconData: Icons.edit,
                    onPressed: () => editField('User name'),
                  ),
                  SizedBox(height: 10),
                  TextBox(
                    text: userData["Phone"],
                    sectionName: 'Phone',
                    iconData: Icons.edit,
                    onPressed: () => editField('Phone'),
                  ),
                  SizedBox(height: 10),

                  firebaseButton(context, "Add items to your list ", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProduct()));
                  }),
                  SizedBox(height: 10),
                  firebaseButton(context, "ADDED ITEMS", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddedItemsPage()));
                  }),

                  SizedBox(height: 10),

                  // firebaseButton(context, "Seller account", () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => Seller_Profile()));
                  // }),

                  SizedBox(height: 10),

                  firebaseButton(context, "Logout", () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  }),
                ],
              );
            } else if (snapshot.hasError) {
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
      return AssetImage("assets/prof_bg3.png");
    }
  }
}
