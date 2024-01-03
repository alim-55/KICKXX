

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kickxx/reset_password.dart';
import 'HomePage.dart';
import 'reusable_widget.dart';
import 'signup_screen.dart';
import 'reset_password.dart';
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
                reusableTextField("Email", Icons.email_outlined, false, _emailTextController,f1,f2,context,(){}),
                SizedBox(height: 30),
                reusableTextField("Password", Icons.lock_outline, true, _passwordTextController,f2,f2,context,(){
                  FocusScope.of(context).unfocus();
                }),
                SizedBox(height: 3),


                forgetPass(context),


                firebaseButton(context, "Sign In", ()=>_signin(_emailTextController.text, _passwordTextController.text)),

                signUpOption(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _signin(String _emailTextController, String _passwordTextController)async{
    try{
      if ( _emailTextController.isEmpty || _passwordTextController.isEmpty ) {
        Fluttertoast.showToast(msg: 'Please fill in all fields', gravity: ToastGravity.TOP);
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController, password: _passwordTextController);
      final currentUser =FirebaseAuth.instance.currentUser!;
      Fluttertoast.showToast(msg: "Successfully logged in as ${currentUser.email}", gravity: ToastGravity.TOP);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));

    } on FirebaseAuthException catch(error){
      print('Error Code: ${error.code}');
      Fluttertoast.showToast(msg: "can't log you in with that username & password", gravity: ToastGravity.TOP);
    }
  }
  //Text....
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
  Widget forgetPass (BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.right,
        ),
        onPressed: (){
         // onTap(
             Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassScreen()));
         // );
        },
      ),
    );
  }
}
