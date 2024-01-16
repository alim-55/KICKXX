import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kickxx/CartProvider.dart';
import 'package:kickxx/row_items.dart';
import 'package:kickxx/ColoumItem.dart';
import 'package:kickxx/NotificationPage.dart';
import 'package:kickxx/AccountPage.dart';
import 'package:kickxx/FavoritePage.dart';
import 'package:kickxx/BottomNavigation.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/src/badge_animation.dart';
import 'package:provider/provider.dart';
import 'DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'KICKXX',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.shopping_bag),
                color: Colors.white,
              ),
              Consumer<cartProvider>(builder: (context, value, child) => badges.Badge(
                  badgeContent: Text(
                    value.getCounter().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  position: badges.BadgePosition.topEnd(top: 0, end: 0),
                ))
            ],
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
            ChangeNotifierProvider.value(
                value: Provider.of<cartProvider>(context),
                child: ColoumWidget()),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavigation(),
    );
  }
}
