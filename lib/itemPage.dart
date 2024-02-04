//import 'dart:js_interop';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kickxx/seller_profile.dart';
import 'package:kickxx/Notification_Service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'BrandProductsPage.dart';

class ItemPage extends StatefulWidget {
  final DocumentSnapshot product;

  const ItemPage({Key? key, required this.product}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late String sellerName = "";

  String brandName = "";
  final LocalNotificationService _notificationService =
  LocalNotificationService();
  int? selectedSize;
  int selectedImageIndex = 0;
  List<String> availableSizes = [];

  @override
  void initState() {
    super.initState();
    // Retrieve sizes from the product document
    dynamic rawAvailableSizes = widget.product['shoeSizes'];
    if (rawAvailableSizes is List) {
      availableSizes =
      List<String>.from(rawAvailableSizes.map((e) => e.toString()));
    } else if (rawAvailableSizes is String) {
      availableSizes.add(rawAvailableSizes.toString());
    }
  }

  Future<void> addToCart() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      var currentUser = _auth.currentUser;
      print("Current User: $currentUser");

      CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection("Cart");

      await _collectionRef.doc(currentUser!.email).collection("items").doc().set(
        {
          "productName": widget.product["productName"],
          "productPrice": widget.product["productPrice"],
          "sellerId": widget.product["sellerId"],
          "imageUrls": widget.product["imageUrls"][0],
        },
      );
      print("Product added to cart successfully");
    } catch (e) {
      print("Error adding product to cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> productData =
    widget.product.data() as Map<String, dynamic>;

    List<String> imageUrls =
    List<String>.from(productData['imageUrls'] ?? []);

    brandName = productData['brandName'].toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display the main product image
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: 350,
              child: GestureDetector(
                onTap: () {

                },
                child: Image.network(
                  imageUrls.isNotEmpty ? imageUrls[selectedImageIndex] : '',
                ),
              ),
            ),
            SizedBox(height: 10),
            // Display thumbnail images
            Container(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selectedImageIndex == index
                            ? Colors.deepPurple.withOpacity(0.7)
                            : Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedImageIndex == index
                              ? Colors.deepPurple
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.network(
                        imageUrls[index],
                        width: 70,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            // Display product details and information
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Display product name and brand
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData['productName'] ?? '',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      // Display brand logo based on brandName
                      Row(
                        children: [
                          Text(
                            "Brand: ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(width: 6),
                          getBrandLogo(brandName),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Display product price and selected size
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Size: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple,
                            ),
                          ),
                          selectedSize != null
                              ? Text(
                            selectedSize.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple,
                            ),
                          )
                              : Text(
                            'Not selected',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (selectedSize == null) {
                            _notificationService.showNotification(
                              id: 2,
                              title: 'Size Not Selected',
                              body:
                              'Please select a size before adding to the cart.',
                            );
                          } else {
                            addToCart();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            '\$ ${productData['productPrice'] ?? ''}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Display seller information
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
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
                      sellerName = sellerData['User name'];
                      print('Seller data: ${sellerData.data()}');

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Seller: $sellerName',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepPurple,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Seller_Profile(
                                    sellerData: sellerData,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 1),
                  // Display product description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
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
                  SizedBox(height: 10),
                  // Display dropdown for selecting sneaker size
                  Container(
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
                          .map(
                            (size) => DropdownMenuItem<int>(
                          value: int.parse(size),
                          child: Text(
                            size,
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Additional information about the product
                  // ...
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          if (selectedSize == null) {
            _notificationService.showNotification(
              id: 2,
              title: 'Size Not Selected',
              body: 'Please select a size before adding to the cart.',
            );
          } else {
            addToCart();
          }
        },
        child: Icon(
          Icons.shopping_cart_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper method to get the brand logo based on brandName
  Widget getBrandLogo(String brandName) {
    switch (brandName) {
      case 'nike':
        return GestureDetector(
          onTap: () {
            navigateToBrandProductsPage(brandName);
          },
          child: Image.asset(
            'assets/nike.png',
            height: 40,
            width: 40,
          ),
        );
      case 'adidas':
        return GestureDetector(
          onTap: () {
            navigateToBrandProductsPage(brandName);
          },
          child: Image.asset(
            'assets/adidas.png',
            height: 40,
            width: 40,
          ),
        );
      case 'newbalance':
        return GestureDetector(
          onTap: () {
            navigateToBrandProductsPage(brandName);
          },
          child: Image.asset(
            'assets/newbalance.png',
            height: 40,
            width: 40,
          ),
        );
      case 'puma':
        return GestureDetector(
          onTap: () {
            navigateToBrandProductsPage(brandName);
          },
          child: Image.asset(
            'assets/puma.png',
            height: 40,
            width: 40,
          ),
        );
      case 'vans':
        return GestureDetector(
          onTap: () {
            navigateToBrandProductsPage(brandName);
          },
          child: Image.asset(
            'assets/Vans-Logo.png',
            height: 40,
            width: 40,
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  // Helper method to navigate to BrandProductsPage with the given brandName
  void navigateToBrandProductsPage(String brandName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandProductsPage(
          brandName: brandName,
        ),
      ),
    );
  }
}
