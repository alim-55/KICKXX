import 'package:flutter/material.dart';
Widget customimageField(){
  TextEditingController _textEditingController = TextEditingController();

  return Container(
    width: 100,
    height: 80,
    decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(8.0),

    ),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            onTap: () {
// Handle the onTap action here
// You can add the logic to perform when the "+" sign is tapped
              print("You tapped the + sign");
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
    ),
  );
}




