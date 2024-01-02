import 'package:flutter/material.dart';
import 'AccountPage.dart';
class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const TextBox({super.key,
  required this.text,
  required this.sectionName,
  required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  sectionName,
                style: TextStyle(color: Colors.white70),
              ),
              
              IconButton(onPressed: onPressed,
                  icon: Icon(Icons.settings,
                  color: Colors.grey,

                  )),
            ],
          ),
          Text(
              text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          ),
        ],
        
      ),
    );
  }
}
