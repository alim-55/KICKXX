import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kickxx/itemPage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ColoumWidget extends StatefulWidget {
  @override
  State<ColoumWidget> createState() => _ColoumWidgetState();
}

class _ColoumWidgetState extends State<ColoumWidget> {
  Map<String, bool> favoriteStates = {};
  void fav(String productID) async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('favourites')
        .doc(productID)
        .get();
    setState(() {
      favoriteStates[productID]= documentSnapshot.exists;
    });
  }

  void setFav(String productID) async {
    //print(productID);
    if (favoriteStates[productID]== true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('favourites')
          .doc(productID)
          .delete();
      setState(() {
        favoriteStates[productID] = false;
      });
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection("favourites")
          .doc(productID)
          .set({});
      setState(() {
        favoriteStates[productID] = true;
      });
    }
  }
  String? _selectedSortingOption;
  String? _selectedColor;
  List<String> _colorOptions = ['red', 'green', 'blue', 'brown', 'white','black','orange','others'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // UI element for selecting sorting criteria
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.deepPurple[300],),
          child: DropdownButton<String>(
            hint:Text( "sort"),
            borderRadius: BorderRadius.circular(30.0),
            icon: Icon(Icons.menu),
            focusColor: Colors.white70,
            value: _selectedSortingOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSortingOption = newValue;
              });
            },
            items: <String>['Price High to Low','Price Low to High',
              'Color'
            ] // Add other sorting options here
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(

                value: value,
                child: Container(
                  color: Colors.transparent,
                  child: Text(value,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (_selectedSortingOption == 'Color') ...[
          SizedBox(height: 10),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.deepPurple[300],),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(30.0),
              menuMaxHeight: 250,
              value: _selectedColor,
              hint: Text('color'),

              onChanged: (String? newValue) {
                setState(() {
                  _selectedColor = newValue;
                });
              },
              items: <String>['red', 'green', 'blue', 'brown', 'white','black','orange','others']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        StreamBuilder<QuerySnapshot>(
          stream: _getStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: LoadingAnimationWidget.fallingDot(
                  color: Colors.white,
                  size: 50,
                ),
              );
            }

            return GridView.count(
              childAspectRatio: .68,
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              padding: EdgeInsets.all(6.0),
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < snapshot.data!.docs.length; i++)
                  _buildProductCard(snapshot.data!.docs[i]),
              ],
            );
          },
        ),
      ],);
  }

  Stream<QuerySnapshot> _getStream() {
    // Construct and return the Firestore stream based on the selected sorting option
    if (_selectedSortingOption != null) {
      if (_selectedSortingOption == 'Price High to Low') {
        return FirebaseFirestore.instance
            .collection('products')
            .orderBy('productPrice', descending: true)
            .snapshots();
      } else if (_selectedSortingOption == 'Price Low to High') {
        return FirebaseFirestore.instance
            .collection('products')
            .orderBy('productPrice', descending: false) // Descending order
            .snapshots();
      }
      else if (_selectedSortingOption == 'Color' && _selectedColor != null) {
        return FirebaseFirestore.instance
            .collection('products')
            .where('color', isEqualTo: _selectedColor)
            .snapshots();
      } else {
        // Default sorting option or handling other cases
        return FirebaseFirestore.instance.collection('products').snapshots();
      }
    }
    return FirebaseFirestore.instance.collection('products').snapshots();
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
    @override
    void initState() {
      super.initState();
      fav('${product.id}');
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            //animation duration here
            transitionDuration: Duration(milliseconds: 500),

            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(

                opacity: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(
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

                opacity: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(
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
                color: Colors.deepPurple.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*Container(
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
                  ),*/
                  IconButton(
                      onPressed: () => {
                        setFav('${product.id}'),

                      },
                      icon: favoriteStates[product.id]==true
                          ? Icon(
                        Icons.favorite_sharp,
                        color: Colors.deepPurple,
                      )
                          : Icon(
                        Icons.favorite_border_sharp,
                        color: Colors.deepPurple,
                      )),
                ],
              ),

              Container(
                margin: EdgeInsets.all(10),
                height: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 1,
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
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Sneaker Name:',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),),
                    ),
                    Center(
                      child: Text(
                        productData['productName'] ,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Price: \$${productData['productPrice'] ?? ''}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        /*SizedBox(height: 5,),
                        Expanded(child: Text('Seller: ${productData['sellerName'] ?? ''}',
                            style: TextStyle(
                              fontSize: 1,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,)),
                        )*/
                        /*Expanded(
                          child: IconButton(
                            onPressed: () => {},
                            icon: Icon(
                              Icons.shopping_cart_sharp,
                              color: Colors.deepPurple,
                            ),
                          ),
                        )*/
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