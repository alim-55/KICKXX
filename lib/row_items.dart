import 'dart:async';
import 'package:flutter/material.dart';
import 'BrandProductsPage.dart';

class RowItemsWidget extends StatefulWidget {
  @override
  State<RowItemsWidget> createState() => _RowItemsWidgetState();
}

class _RowItemsWidgetState extends State<RowItemsWidget> {
  final PageController _pageController =
  PageController(initialPage: 100, viewportFraction: 0.8);
  final int itemCount = 5;
  final Duration autoScrollDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final int pageIndex = index % itemCount + 1;
          return _buildShoeCard(pageIndex);
        },
      ),
    );
  }

  Widget _buildShoeCard(int index) {
    final String brandName = _getBrandName(index);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandProductsPage(brandName: brandName),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/shoe$index.png",
            height: 150,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  String _getBrandName(int index) {
    switch (index) {
      case 1:
        return 'nike';
      case 2:
        return 'adidas';
      case 3:
        return 'newbalance';
      case 4:
        return 'puma';
      case 5:
        return 'vans';
      default:
        return '';
    }
  }

  void _startAutoScroll() {
    Timer.periodic(autoScrollDuration, (timer) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
