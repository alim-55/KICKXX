import 'package:flutter/material.dart';
import 'text_box.dart';
class Seller_Profile extends StatefulWidget {
  const Seller_Profile({super.key});

  @override
  State<Seller_Profile> createState() => _Seller_ProfileState();
}

class _Seller_ProfileState extends State<Seller_Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Seller Profile',
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
        child:  ListView(
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
                           // backgroundImage: _selectedImage(userData['profilePicture']),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                     // currentUser.email!,
                      'Email',
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
                    text: "User name",
                    iconData: Icons.message_rounded,
                    sectionName: 'Username',
                    onPressed: () {},
                  ),
                  SizedBox(height: 10),
                  TextBox(
                    text: "Phone",
                    iconData: Icons.phone,
                    sectionName: 'Phone', onPressed: () {  },
                    //onPressed: () => editField('Phone'),
                  ),


                  SizedBox(height: 10),

                ],
              )
            // rn Center(child: CircularProgressIndicator());

        ),

  );
  }
}
