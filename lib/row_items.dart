import 'package:flutter/material.dart';
import 'package:kickxx/product.dart';
import 'package:kickxx/itemPage.dart';

List<String> Events = [
  "Black Friday",
  "Clearance",
  "Christmas",
  "New Released"
];

class RowItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 1; i < 5; i++)
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          right: 70,
                        ),
                        height: 130,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Image.asset(
                        "assets/shoe$i.png",
                        height: 180,
                        width: 220,
                        fit: BoxFit.contain,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          Events[i - 1],
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          Events[i - 1],
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.shopping_cart, color: Colors.deepPurple,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
