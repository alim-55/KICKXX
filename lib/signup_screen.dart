

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/HomePage.dart';
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
  FocusNode f1 =FocusNode();
  FocusNode f2 =FocusNode();
  FocusNode f3 =FocusNode();
  FocusNode f4 =FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                      backgroundImage: AssetImage("assets/prof_bg3.jpg"),
                    ),
                    Positioned(
                        bottom: 20,
                        right: 20,
                        child: Icon(
                          Icons.camera_alt_outlined,
                              color: Colors.teal,
                          size: 20,

                        )),
                  ],),
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
                signInSignUpButton(context, false, (){


                   // Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));

                  FirebaseAuth.instance.createUserWithEmailAndPassword(email: _mailTextController.text,
                      password: _passwordTextController.text).then((value){
                        print("Created new account");
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });




                  /*.onError((error, stackTrace) {
                    print("Error ${error.toString()}");*/
                  // });


                })
              ],
            ),
          ),
        ),

      ),
    );
  }
}
