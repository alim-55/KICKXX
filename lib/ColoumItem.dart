import 'package:flutter/material.dart';

class ColoumWidget extends StatelessWidget {
  const ColoumWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        childAspectRatio: .68,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: [
          for(int i =1;i<=10;i++)
          Container(
            padding: EdgeInsets.only(left: 20,right:20,top: 20),
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "HOT",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.add_box_outlined,
                      color: Colors.deepPurple,
                    )
                  ],
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Image.network('https://www.kickgame.co.uk/cdn/shop/products/Air-Jordan-1-Low-CQ4277-001-Travis_1.png?v=1659088883'),
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
                Padding(padding:
                EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          "\$250",
                          style:
                          TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.shopping_cart,color: Colors.deepPurple,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
