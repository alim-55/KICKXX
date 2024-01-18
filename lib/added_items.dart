import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddedItemsPage extends StatefulWidget {
  @override
  _AddedItemsPageState createState() => _AddedItemsPageState();
}

class _AddedItemsPageState extends State<AddedItemsPage> {
  late User currentUser;

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Added Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('sellerId', isEqualTo: currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No added items found.'),
            );
          }

          // Display the added items in cards
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var product =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;
// Get the list of image URLs
              List<String> imageUrls = List<String>.from(product['imageUrls']);

              // Display the first image
              Widget imageWidget = SizedBox.shrink();
              if (imageUrls.isNotEmpty) {
                imageWidget = Image.network(
                  imageUrls.first,
                  width: 100.0, // Adjust the width as needed
                  height: 100.0, // Adjust the height as needed
                  fit: BoxFit.cover,
                );
              }
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: imageWidget,
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(
                        context,
                        snapshot.data!.docs[index].reference,
                      );
                    },
                  ),
                  title: Text(product['productName']),
                  subtitle: Text('Price: \$${product['productPrice']}'),
                  // Add more details as needed
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context,
      DocumentReference productReference,
      ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text('Are you sure you want to remove this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await productReference.delete(); // Delete item from Firestore
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }


}
