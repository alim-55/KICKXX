import 'package:flutter/material.dart';
import 'package:kickxx/CartModel.dart';
import 'package:kickxx/CartProvider.dart';
import 'package:kickxx/DatabaseHelper.dart';
import 'package:kickxx/itemPage.dart';
import 'package:kickxx/productPage.dart';
import 'package:provider/provider.dart';


class ColoumWidget extends StatefulWidget {
  ColoumWidget({Key? key}) : super(key: key);

  @override
  State<ColoumWidget> createState() => _ColoumWidgetState();
}

class _ColoumWidgetState extends State<ColoumWidget> {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cartProvider>(context);
    return GridView.count(
      childAspectRatio: .68,
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      children: [
        for (int i = 1; i <= 10; i++)
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "HOT",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(
                        Icons.favorite_border_sharp,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(1),
                      child: Image.network(
                          'https://www.kickgame.co.uk/cdn/shop/products/Air-Jordan-1-Low-CQ4277-001-Travis_1.png?v=1659088883'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sneaker:",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    child: Text(
                      "Cactus Jack Mocha Low",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          "\$250",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () => {},
                          icon: InkWell(
                            onTap: ()  {
                               dbHelper.insert(cartModel(
                                  name: 'Jordan 1 Cactus Jack',
                                  imageURL:
                                  'https://www.kickgame.co.uk/cdn/shop/products/Air-Jordan-1-Low-CQ4277-001-Travis_1.png?v=1659088883',
                                  price: 250,
                                  quantitiy: 1,
                                  finalPrice: 250 * 1));
                              cart.addCounter();
                              cart.addTotalPrice(250);
                              print('Product is added to the cart');
                            },
                            child: Icon(
                              Icons.shopping_cart_sharp,
                              color: Colors.deepPurple,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
