import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kickxx/ChatPage.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int? selectedSize;

  List<String> _images = List.generate(4, (index) => "assets/shoe1.png");

  @override
  Widget build(BuildContext context) {
    List<String> sizes = List.generate(9, (index) => (38 + index).toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: 300,
                height: 400,
                child: Image.network(
                  'https://www.kickgame.co.uk/cdn/shop/products/Air-Jordan-1-Low-CQ4277-001-Travis_1.png?v=1659088883',
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        _images[i],
                        width: 70,
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Travis Scott X Air Jordan 1 Low',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            '\$ 250',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Quality : Brand New',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            'Selling by : Nike',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(
                            width: 180,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    receiverUserId: 'a',
                                    receiverUserEmail: 'e@gmail.com',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.deepPurple,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Description :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                              'Building off the success of their previous collaborations, Travis Scott adds yet another new design to his collaborative relationship with Jumpman via the Air Jordan 1 Low Travis Scott, now available on StockX. Travis teased the release of this shoe while on his Astroworld tour, leaving fans of both his music and the Jordan Brand alike with one question: When are these shoes dropping? On the Friday night of July 19, 2019, Travis answered the masses by making them available on his website, with a release on the SNKRS app following the next day.'
                              'This AJ 1 Low features a black upper with dark brown overlays and red accents on the branding. Much like the Air Jordan 1 High Travis Scott, La Flame added his signature backwards Swoosh logo on the lateral side. Cactus Jack insignias on the heel and inner upper atopa sail midsole and dark brown outsole completes the design. These sneakers released in July of 2019 and retailed for \$ 130.')
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton<int>(
                          hint: Text(
                            'Select Sneaker Size',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: selectedSize,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSize = newValue;
                            });
                          },
                          items: List.generate(11, (index) => index + 38)
                              .map((size) => DropdownMenuItem<int>(
                                    value: size,
                                    child: Text(
                                      '$size',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          //cart e jabe
        },
        child: Container(
          child: Icon(
            Icons.shopping_cart_sharp,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
