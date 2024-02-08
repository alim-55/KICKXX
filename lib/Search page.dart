import 'package:flutter/material.dart';
import 'package:kickxx/BrandProductsPage.dart';
import 'package:kickxx/SearchResultPage.dart';

import 'ColoumItem.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            'Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white), // Set text color
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
                    ),
                  ),
                  SizedBox(width: 16.0),
                  IconButton(
                    onPressed: () {
                      // Perform search action
                      String query = _searchController.text;
                      if (_searchController.text == "nike" ||
                          _searchController.text == "adidas" ||
                          _searchController.text == "newbalance") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrandProductsPage(
                              brandName: _searchController.text,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultPage(
                                productName:
                                _searchController.text.toLowerCase()),
                          ),
                        );
                      }
                      print('Search query: $query');
                    },
                    icon: Icon(Icons.search, color: Colors.white), // Set icon color
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child:  Column(
                    children: [
                      // Add your scrollable content here
                      ColoumWidget(),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
