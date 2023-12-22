

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'reusable_widget.dart';
import 'signup_screen.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController= TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  FocusNode f1 =FocusNode();
  FocusNode f2 =FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black,Colors.deepPurple,Colors.black,Colors.deepPurple,Colors.black,Colors.deepPurple,Colors.black],
              //[Colors.grey.shade200, Colors.grey.shade200, Colors.grey.shade200],
              // [Color(0xFF001F3F), Color(0xFFFF6F61)],
              //[Color(0xFF800020), Color(0xFFF7E7CE)],
              //[Color(0xFF008080), Color(0xFFFF6F61)],
              //[Colors.white, Colors.grey.shade300, Colors.grey, Colors.grey.shade700, Colors.grey.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height*0.15, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget('assets/logo3.png'),
                SizedBox(height: 90),
                reusableTextField("Enter Username", Icons.verified_user, false, _emailTextController,f1,f2,context,(){}),
                SizedBox(height: 30),
                reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController,f2,f2,context,(){
                  FocusScope.of(context).unfocus();
                }),
                SizedBox(height: 20),
                signInSignUpButton(context, true, (){
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text,
                      password: _passwordTextController.text).then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));
                  });
                }),
                signUpOption()

              ],
            ),
          ),
        ),
      ),
    );
  }
  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
          style: TextStyle(color: Colors.white70),),
        SizedBox(width: 10),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));

          },
          child: Text(
            "-Sign Up",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),

      ],
    );
  }
}
