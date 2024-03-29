import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kickxx/NotificationPage.dart';
import 'package:kickxx/AccountPage.dart';
//import 'package:kickxx/FavoritePage.dart';
import 'package:kickxx/HomePage.dart';
import 'package:kickxx/Search%20page.dart';
import 'package:kickxx/add_product.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<BottomNavigation> {
  int index = 0;

  final screens = [
    HomePage(),
    SearchPage(),
    NotificationPage(payload: 'nothing',),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      // Prevent navigation when back button is pressed
      if (index != 0) {
        setState(() => index = 0);
        return false;
      }
      return true;
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        index: index,
        backgroundColor: Colors.deepPurple,
        color: Colors.deepPurpleAccent.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: (selectedIndex) {
          setState(() => index = selectedIndex);
        },
        items: [
          _buildNavItem(Icons.home, 'Home'),
          _buildNavItem(Icons.search_outlined, 'Search'),
          _buildNavItem(Icons.notifications, 'Notification'),
          _buildNavItem(Icons.account_circle, 'Account'),
        ],
      ),
    ),
  );

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 0.5),
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}