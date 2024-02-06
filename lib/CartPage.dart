import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late User currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = FirebaseAuth.instance.currentUser!;
  }

  double calculateTotalPrice(List<DocumentSnapshot> cartItems) {
    double totalAmount = 0.0;

    for (DocumentSnapshot item in cartItems) {
      double itemPrice = item['productPrice'].toDouble();
      totalAmount += itemPrice;
    }

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
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
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Cart")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Your cart is empty",style: TextStyle(color: Colors.white, fontSize: 20),));
              }
              double totalAmount = calculateTotalPrice(snapshot.data!.docs);
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        DocumentSnapshot _documentSnapshot =
                        snapshot.data!.docs[index];
                        String imageUrl = _documentSnapshot['imageUrls'];

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                padding: EdgeInsets.all(20.0),
                                borderRadius: BorderRadius.circular(15.0),
                                autoClose: true,
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (context) =>
                                    _showDeleteConfirmationDialog(
                                      context,
                                      snapshot.data!.docs[index].reference,
                                    ),
                              ),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            child: Container(
                              width: double.infinity,
                              //height: 110.0,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                leading: Container(
                                  //margin: EdgeInsets.all(10),
                                  //height: 150,
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
                                      imageUrl,
                                      width: 110,
                                      //height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  _documentSnapshot['productName'],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "\$ ${_documentSnapshot['productPrice']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      //color: Colors.deepPurple, // Background color
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.deepPurple)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              'Total: \$${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Implement checkout functionality
                              _showPaymentBottomSheet(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple, // Background color
                              onPrimary: Colors.white, // Text color
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context,
      DocumentReference productReference,) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text('Are you sure you want to remove this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await productReference.delete();
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPaymentBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose a Payment Method',
                style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                // Adjust the circular border radius as needed
                child: Material(
                  elevation: 6,
                  // Adjust the elevation to control the shadow intensity
                  borderRadius: BorderRadius.circular(20),
                  // Same circular border radius as ClipRRect
                  child: ListTile(
                    title: Text('Online Payment'),
                    onTap: () {
                      // Handle credit card payment
                      Navigator.pop(context);
                      _showSuccessAlert();
                    },
                  ),
                ),
              ),
              SizedBox(height: 16,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                // Adjust the circular border radius as needed
                child: Material(
                  elevation: 4,
                  // Adjust the elevation to control the shadow intensity
                  borderRadius: BorderRadius.circular(20),
                  // Same circular border radius as ClipRRect
                  child: ListTile(
                    title: Text('Cash on Delivery'),
                    onTap: () {
                      // Handle credit card payment
                      Navigator.pop(context);
                      _showSuccessAlert();
                    },
                  ),
                ),
              ),
              // Add more payment methods as needed
            ],
          ),
        );
      },
    );
  }

  void _showSuccessAlert() {
    QuickAlert.show(
      context: context,
      confirmBtnColor: Colors.deepPurple,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Product ordered successfully!',
      //duration: Duration(seconds: 2),
    );
    // Empty the cart
    FirebaseFirestore.instance
        .collection("Cart")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
