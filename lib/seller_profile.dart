import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'text_box.dart';
class Seller_Profile extends StatefulWidget {
  final DocumentSnapshot sellerData;

  const Seller_Profile({Key? key, required this.sellerData}) : super(key: key);
  @override
  State<Seller_Profile> createState() => _Seller_ProfileState();
}

class _Seller_ProfileState extends State<Seller_Profile> {


  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? sellerData = widget.sellerData?.data() as Map<String, dynamic>?;
    if (sellerData == null) {
      // Show loading or error state
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Seller Profile',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black, Colors.deepPurple, Colors.black, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
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
                       backgroundImage: _selectedImage(sellerData['profilePicture']),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                sellerData['Email']  , // Adjust the field name accordingly
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
                "Seller Details",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Display seller details (adjust field names accordingly)
            TextBox(
              text: sellerData['User name'] ,
              iconData: Icons.message_rounded,
              sectionName: 'Username',
              onPressed: () {},
            ),
            SizedBox(height: 10),
            TextBox(
              text: sellerData['Phone'] ,
              iconData: Icons.phone,
              sectionName: 'Phone',
              onPressed: () {},
            ),
            SizedBox(height: 10),
          ],
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
