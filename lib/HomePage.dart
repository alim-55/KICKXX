import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kickxx/row_items.dart';
import 'package:kickxx/ColoumItem.dart';
import 'package:kickxx/NotificationPage.dart';
import 'package:kickxx/AccountPage.dart';
import 'package:kickxx/FavoritePage.dart';
import 'package:kickxx/BottomNavigation.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'KICKXX',
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w600,),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.deepPurple,
              Colors.black,
              Colors.deepPurple,
              Colors.black,
              Colors.deepPurple,
              Colors.black
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            RowItemsWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.deepPurple,
                      style: TextStyle(color: Colors.deepPurple),
                      //textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.white.withOpacity(1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                      onChanged: (t) {
                        TextStyle(color: Colors.deepPurple);
                        print(t);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Perform search action
                      },
                      icon: Icon(Icons.search, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ColoumWidget(),
          ],
        ),

      ),
      //bottomNavigationBar: BottomNavigation(),

    );

  }
}
