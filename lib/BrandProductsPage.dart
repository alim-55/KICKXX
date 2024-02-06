import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kickxx/itemPage.dart';

class BrandProductsPage extends StatefulWidget {
  final String brandName;

  BrandProductsPage({required this.brandName});

  @override
  State<BrandProductsPage> createState() => _BrandProductsPageState();
}

class _BrandProductsPageState extends State<BrandProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.brandName} Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:
    Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.deepPurple, Colors.black, Colors.deepPurple, Colors.black, Colors.deepPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('brandName', isEqualTo: widget.brandName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No ${widget.brandName} products found.'),
            );
          }

          return ListView(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: .68,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(snapshot.data!.docs[index]);
                },
              ),
            ],
          );
        },
      ),
    ),
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

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            // animation duration here
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: ItemPage(product: product),
              );
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              );
            },
          ),
        );
      },
      child: Hero(
        tag: 'product_${product.id}', // Use a unique tag for each product
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
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

              Container(
                margin: EdgeInsets.all(10),
                height: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imageUrls.isNotEmpty ? imageUrls.first : '',
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
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
                        Expanded(
                          child: Text(
                            'Price: \$${productData['productPrice'] ?? ''}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
