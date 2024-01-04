

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickxx/HomePage.dart';
import 'package:kickxx/signin_screen.dart';
import 'main.dart';
import 'reusable_widget.dart';
import 'HomePage.dart';

import 'package:flutter/material.dart';
import 'reusable_widget.dart';
import 'signup_screen.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController= TextEditingController();
  TextEditingController _mailTextController=TextEditingController();
  TextEditingController _userNameTextController=TextEditingController();
  TextEditingController _phoneController= TextEditingController();

  TextEditingController _profilePictureController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _loading = false;
  FocusNode f1 =FocusNode();
  FocusNode f2 =FocusNode();
  FocusNode f3 =FocusNode();
  FocusNode f4 =FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("2nd page"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black,Colors.deepPurple,Colors.black,Colors.deepPurple,Colors.black,Colors.deepPurple,Colors.black],
          //[Colors.black, Colors.black, Colors.black],
          //[Color(0xFF0F52BA), Color(0xFFC0C0C0)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, 128, 20, 0),
            child: Column(

              children: <Widget>[
                Center(
                  child: Stack(children: <Widget>[
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) as ImageProvider<Object> : AssetImage("assets/prof_bg3.jpg"),
                    ),
                    Positioned(
                        bottom: 20,
                        right: 20,
                        child: GestureDetector(onTap: _pickImage,
                          child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              child: _loading
                                  ? CircularProgressIndicator(
                                // Use a CircularProgressIndicator while loading
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                                  : Icon(Icons.camera_alt,
                              color: Colors.grey,

                            )),
                  //   if (_selectedImage != null) Image.file(_selectedImage!),
        ),),],),

                ),
                SizedBox(height: 20),
                reusableTextField("Enter Username", Icons.person_outline, false, _userNameTextController,f1,f2,context,(){}),
                SizedBox(height: 20),
                reusableTextField("Enter Email Id", Icons.person_outline, false, _mailTextController,f2,f3,context,(){}),
                SizedBox(height: 20),
                reusableTextField("Enter Phone number", Icons.phone_android_rounded, false, _phoneController,f3,f4,context,(){}),
                SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController,f4,f4,context,(){
                  FocusScope.of(context).unfocus();
                }),
                SizedBox(height: 20),

                firebaseButton(context, "Sign Up", ()=>_signup(_mailTextController.text, _passwordTextController.text)),
                SizedBox(height: 5),

                signInOption()
              ],
            ),
          ),
        ),

      ),
    );


  }
  Future<void> _pickImage() async {
    try {
      setState(() {
        _loading = true; // Set loading to true when picking image
      });
      final pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _profilePictureController.text = pickedFile.path;
        });
        final storageRef = FirebaseStorage.instance.ref().child(
            'profile_images/${DateTime
                .now()
                .millisecondsSinceEpoch}');
        await storageRef.putFile(_selectedImage!);

        // Retrieve the download URL
        final downloadURL = await storageRef.getDownloadURL();

        setState(() {
          _profilePictureController.text = downloadURL;
        });
      }
    }
    finally {
      setState(() {
        _loading = false; // Set loading to false when done picking image
      });
    }


   // if (_selectedImage != null) Image.file(_selectedImage!);
  }

  /*Future addUserDetails(String name,String email,String phone) async{
    await FirebaseFirestore.instance.collection('users').add({
      'User name': name,
      'Email':email,
      'Phone':phone,
    });
  }*/
  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?",
          style: TextStyle(color: Colors.white70),),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: Text(
            "-Sign In",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

      ],
    );
  }


  _signup(String _mailTextController, String _passwordTextController)async{
    try{
      if (_userNameTextController.text.isEmpty || _mailTextController.isEmpty || _passwordTextController.isEmpty || _phoneController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Please fill in all fields', gravity: ToastGravity.TOP);
        return;
      }
      if (_phoneController.text.length !=11) {
        Fluttertoast.showToast(msg: 'Phone number must have 11 digits', gravity: ToastGravity.TOP);
        return;
      }


     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _mailTextController, password: _passwordTextController);

     final docUser= FirebaseFirestore.instance.collection("users").doc(userCredential.user!.email);
      final json={
        'User name': _userNameTextController.text,
        'Email': _mailTextController,
        'Phone':_phoneController.text,
        'profilePicture': _profilePictureController.text,
      };
      await docUser.set(json);

      Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeWithBottomNavigation()));

    } on FirebaseAuthException catch(error){
      Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
    }
  }


}
