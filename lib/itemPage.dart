import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kickxx/seller_profile.dart';

class ItemPage extends StatefulWidget {
  final DocumentSnapshot product;

  const ItemPage({Key? key, required this.product}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int? selectedSize;
  List<String> availableSizes = [];
  void initState() {
    super.initState();
    // Retrieve sizes from the product document
    dynamic rawAvailableSizes = widget.product['shoeSizes'];
    if (rawAvailableSizes is List) {
      availableSizes = List<String>.from(rawAvailableSizes.map((e) => e.toString()));
    } else if (rawAvailableSizes is String) {
      availableSizes.add(rawAvailableSizes.toString());
    }
  }

  @override

  Widget build(BuildContext context) {
    // Extract product data from the DocumentSnapshot
    Map<String, dynamic> productData = widget.product.data() as Map<String, dynamic>;

    List<String> imageUrls = List<String>.from(productData['imageUrls'] ?? []);
    List<String> sizes = List<String>.from(productData['sizes'] ?? []);

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
                  imageUrls.isNotEmpty ? imageUrls.first : '',
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  for (String imageUrl in imageUrls)
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        imageUrl,
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
                            productData['productName'] ?? '',
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
                            '\$ ${productData['productPrice'] ?? ''}',
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
                        'Quality : ${productData['productQuality'] ?? ''}',
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
                            'Selling by : ${productData['sellerName'] ?? ''}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(
                            width: 180,
                          ),

                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users') // Change to your users collection
                                .doc(productData['sellerId'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (!snapshot.hasData || snapshot.data == null) {
                                print('Seller data not found');
                                return Text('Seller not found');
                              }

                              var sellerData = snapshot.data!;
                              print('Seller data: ${sellerData.data()}');
                              return IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Seller_Profile(sellerData: sellerData),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.deepPurple,
                                ),
                              );
                            },
                          ),

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
                            productData['productDescription'] ?? '',
                          ),
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
                          items: availableSizes
                              .map((size) => DropdownMenuItem<int>(
                            value: int.parse(size),
                            child: Text(
                              size,
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
                    // Additional information about the product
                    // ...
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // Add to cart logic
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
