import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/itemPage.dart';

class ColoumWidget extends StatefulWidget {
  @override
  State<ColoumWidget> createState() => _ColoumWidgetState();
}

class _ColoumWidgetState extends State<ColoumWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No products found.'),
          );
        }

        return GridView.count(
          childAspectRatio: .68,
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing :15.0,
         // mainAxisSpacing: 10.0,
          padding: EdgeInsets.all(6.0),
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (int i = 0; i < snapshot.data!.docs.length; i++)
              _buildProductCard(snapshot.data!.docs[i]),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(DocumentSnapshot product) {
    Map<String, dynamic>? productData = product.data() as Map<String, dynamic>?;

    if (productData == null) {
      return Container(); // or some placeholder widget
    }

    dynamic rawImageUrls = productData['imageUrls'];

    List<String> imageUrls = [];

    if (rawImageUrls is List) {
      imageUrls = List<String>.from(rawImageUrls.map((e) => e.toString()));
    } else if (rawImageUrls is String) {
      imageUrls.add(rawImageUrls.toString());
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10.0,5.0,5.0,5.0),

      decoration:BoxDecoration(
        color: Colors.white60,
      borderRadius: BorderRadius.circular(20.0),
      ),


      // Rest of the existing code for the card...
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
                    builder: (context) => ItemPage(product: product),
                  ),
                );
              },
              child: Expanded(
                child: Container(
                  margin: EdgeInsets.all(1),
                  child: Image.network(
                    imageUrls.isNotEmpty ? imageUrls.first : '',
                    width: 150,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),

            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData['productName'] ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                  Text(
                    'Price: \$${productData['productPrice'] ?? ''}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    Expanded(
                      child: IconButton(
                        onPressed: () => {},
                        icon: Icon(
                      
                          Icons.shopping_cart_sharp,
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                ]
                ),

              ],
            ),
          ),
          // Rest of the existing code for the card...
        ],
      ),
    );
  }


}
