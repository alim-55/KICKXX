

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kickxx/HomePage.dart';
import 'package:kickxx/signin_screen.dart';
import 'reusable_widget.dart';
import 'HomePage.dart';

import 'package:flutter/material.dart';
import 'reusable_widget.dart';
import 'signup_screen.dart';
class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _mailTextController = TextEditingController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

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
        width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Colors.deepPurple, Colors.black, Colors.deepPurple,
            Colors.black, Colors.deepPurple,
            Colors.black
          ],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, 28, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    "Enter Your Email and we will send you and password reset link",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                    textAlign: TextAlign.center,

                  ),

                ),
                SizedBox(height: 20),
                reusableTextField(
                    "Enter Email Id", Icons.email_outlined, false, _mailTextController, f2, f3, context, () {}),

                SizedBox(height: 20),
                firebaseButton(context, "Reset Password", () =>
                    _reset(_mailTextController.text)),
              ],
            ),
          ),
        ),

      ),
    );
  }

  _reset(String _mailTextController) async {
    try {
      if (_mailTextController.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Please fill in your Email id', gravity: ToastGravity.TOP);
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _mailTextController);
      Fluttertoast.showToast(msg: 'Password reset email sent successfully!',
          gravity: ToastGravity.TOP);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
          msg: error.message!, gravity: ToastGravity.TOP);
    }
  }
}