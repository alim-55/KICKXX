import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kickxx/NotificationPage.dart';
import 'package:kickxx/AccountPage.dart';
import 'package:kickxx/FavoritePage.dart';
import 'package:kickxx/HomePage.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<BottomNavigation> {
  int index = 0;

  final screens = [
    HomePage(),
    FavoritePage(),
    NotificationPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: screens[index],
    bottomNavigationBar: CurvedNavigationBar(
      height: 65,
      index: index,
      backgroundColor: Colors.deepPurple,
      color: Colors.deepPurpleAccent.shade200,
      animationDuration: Duration(milliseconds: 300),
      onTap: (selectedIndex) {
        setState(() => index = selectedIndex);
      },
      items: [
        _buildNavItem(Icons.home, 'Home'),
        _buildNavItem(Icons.favorite, 'Favourite'),
        _buildNavItem(Icons.notifications, 'Notification'),
        _buildNavItem(Icons.account_circle, 'Account'),
      ],
    ),
  );
  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 0.5),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

