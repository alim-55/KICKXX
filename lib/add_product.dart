import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickxx/AccountPage.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'product_images.dart';
import 'package:kickxx/Notification_Service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class AddProduct extends StatefulWidget {
   AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final LocalNotificationService _notificationService = LocalNotificationService();

   TextEditingController _productnameTextController= TextEditingController();

   TextEditingController _productPriceTextController= TextEditingController();

   TextEditingController _sellernameTextController= TextEditingController();

   //TextEditingController _productquantityTextController= TextEditingController();

   TextEditingController _productDescriptionTextController= TextEditingController();

   TextEditingController _brandNameTextController= TextEditingController();

   TextEditingController _colorTextController= TextEditingController();
  //final_productquantityTextController=1;

   FocusNode f1 =FocusNode();

   FocusNode f2 =FocusNode();

   FocusNode f3 =FocusNode();

   FocusNode f4 =FocusNode();

   FocusNode f5 =FocusNode();

   FocusNode f6 =FocusNode();

   FocusNode f7 =FocusNode();

   final MultiSelectController _controller = MultiSelectController();
   final MultiSelectController _shoeSizeController = MultiSelectController();

   bool isUploading = false;
   List<ValueItem> selectedShoeCategory = [];

  final List<String> genderItems = [
    'nike',
    'adidas',
    'newbalance'
  ];


   /*final List<String> items = [
     'Nike Lifestyle',
     'Nike Jordan',
     'Nike Air Max',
     'Nike Air Force 1',
     'Nike Dunks & Blazers',
     'Nike Basketball',
     'Nike Running',
     'Nike Sandal & Slides',
   ];*/

   String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: isUploading
            ? Text("Product Uploading ...",
        selectionColor: Colors.white,):Text("Add Product",selectionColor: Colors.white,),
        centerTitle: true,
      ),
      body: isUploading
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black, Colors.deepPurple, Colors.black, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
            child: Center(

                    child: LoadingAnimationWidget.dotsTriangle(color: Colors.white, size: 100)
                  ),
          )
          : SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.black, Colors.deepPurple, Colors.black, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 11),
                    child: const Text('Product Name',style: TextStyle(fontSize: 20,color: Colors.white70),
                      textAlign: TextAlign.start,)),
                const SizedBox(
                  height: 4,
                ),
                reusableTextField("Enter Product name", null, false, _productnameTextController,f1,f2,context,(){}),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(left: 11),
                    child: const Text('Brand ',style: TextStyle(fontSize: 20,color: Colors.white70),
                      textAlign: TextAlign.start,)),
                const SizedBox(
                  height: 4,
                ),
                reusableTextField("Enter Brand name", null, false, _brandNameTextController,f2,f3,context,(){}),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(left: 11),
                    child: const Text(' Color',style: TextStyle(fontSize: 20,color: Colors.white70),
                      textAlign: TextAlign.start,)),
                const SizedBox(
                  height: 4,
                ),
                reusableTextField("Enter Shoe Color", null, false, _colorTextController,f3,f4,context,(){}),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(left: 11),
                    child: const Text(' Description',style: TextStyle(fontSize: 20,color: Colors.white70),
                      textAlign: TextAlign.start,)),
                const SizedBox(
                  height: 4,
                ),
                reusableTextField("Enter Product Description", null, false, _productDescriptionTextController,f4,f5,context,(){}),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(left: 11),
                    child: const Text(' Price',style: TextStyle(fontSize: 20,color: Colors.white70),
                      textAlign: TextAlign.start,)),
                const SizedBox(
                  height: 4,
                ),
                reusableTextField("Enter Product Price", null, false, _productPriceTextController,f5,f6,context,(){}),
                SizedBox(height: 10.0),
                // reusableTextField("Enter Product's Quantity", null, false, _productquantityTextController,f6,f7,context,(){}),
                // SizedBox(height: 10.0),


                Container(
                    padding: EdgeInsets.only(left: 11),
                    child: const Text('Shoe Size',style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,)),
                const SizedBox(
                  height: 4,
                ),
                MultiSelectDropDown(
                  controller: _shoeSizeController,
                  onOptionSelected: (List<ValueItem> selectedOptions) {},
                  options: const <ValueItem>[
                    ValueItem(label: '10', value: '1'),
                    ValueItem(label: '11', value: '2'),
                    ValueItem(label: '12', value: '3'),
                    ValueItem(label: '13', value: '4'),
                    ValueItem(label: '14', value: '5'),
                    ValueItem(label: '15', value: '6'),
                  ],
                  hint: "Select your Shoe size",
                  hintColor: Colors.black,
                  hintFontSize: 14.0,
                  borderColor: Colors.transparent,
                  selectedOptionBackgroundColor:Colors.white70,
                  optionsBackgroundColor:Colors.deepPurple[100],


                  selectionType: SelectionType.single,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  borderRadius: 20.0,
                  fieldBackgroundColor:Colors.white70.withOpacity(0.8),
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _shoeSizeController.clearAllSelection();
                      },
                      child: const Text('CLEAR'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                 /*   ElevatedButton(
                      onPressed: () {
                        debugPrint(_controller.selectedOptions.toString());
                      },
                      child: const Text('Get Selected Options'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),*/
                    ElevatedButton(
                      onPressed: () {
                        if (_shoeSizeController.isDropdownOpen) {
                          _shoeSizeController.hideDropdown();
                        } else {
                          _shoeSizeController.showDropdown();
                        }
                      },
                      child: const Text('SHOW/HIDE DROPDOWN'),
                    ),
                  ],
                ),

                SizedBox(height: 40),


            Center(

              child: Container(

                /*child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Select Your Gender',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: genderItems
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select gender.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),*/



                /*child: MultiSelectDropDown(
                  controller: _controller,
                  onOptionSelected: (List<ValueItem> selectedOptions) {
                    setState(() {
                      selectedShoeCategory = selectedOptions;
                    });
                  },
                  options: const <ValueItem>[
                    ValueItem(label: 'Nike Lifestyle', value: '1'),
                    ValueItem(label: 'Nike Jordan',value: '2'),
                    ValueItem(label: 'Nike Air Max', value: '3'),
                    ValueItem(label: 'Nike Air Force 1', value: '4'),
                    ValueItem(label: 'Nike Dunks & Blazers', value: '5'),
                    ValueItem(label: 'Nike Basketball', value: '6'),
                    ValueItem(label: 'Nike Running', value: '7'),
                    ValueItem(label: 'Nike Sandal & Slides', value: '8'),


                  ],
                  hint: "Select Shoe catagory",
                  hintColor: Colors.white,
                  hintFontSize: 18.0,
                  borderColor: Colors.transparent,
                  selectedOptionBackgroundColor:Colors.white70,
                  optionsBackgroundColor:Colors.deepPurple[100],
searchBackgroundColor: Colors.redAccent,
                  //selectedOptionTextColor: Colors.white,

                  selectionType: SelectionType.single,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  borderRadius: 20.0,
                  fieldBackgroundColor:Colors.white.withOpacity(0.3),
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),*/
              ),
            ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 11),
                  child: Text("Add Product Images",
                  style: TextStyle(color: Colors.black,
                  fontSize: 20,
                 // fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                SizedBox(height: 10),
                Column(

                  children:<Widget>[ Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:<Widget> [
                      //customimageField(pickImages(0), pickImages()),customimageField(_pickedImage,pickImages),customimageField(_pickedImage,pickImages),
                      customimageField(0, () => pickImages(0)),
                      customimageField(1, () => pickImages(1)),
                      customimageField(2, () => pickImages(2)),
                    ],
                  ),
                  SizedBox(height: 15),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:<Widget> [
                      customimageField(),customimageField(),customimageField(),
                    ],
                  ),*/
                  ],
                ),
                SizedBox(height: 15),
                firebaseButton(context, "Add Product ", () =>uploadProduct()

                ),



              ],
            ),
          ),
        ),
      ),
    );
  }


   List<File> productImages = [];
   List<XFile?> _pickedImages = List.generate(3, (index) => null); // Adjust the size based on your needs

   Future<void> pickImages(int index) async {

     List<XFile>? pickedFiles;
     try {
       //List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(source: ImageSource.gallery, imageQuality: 80);
       final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
       if (pickedImage != null) {
         setState(() {
           //productImages = pickedFiles!.map((file) => File(file.path)).toList();
           _pickedImages[index] = pickedImage;
           productImages.add(File(pickedImage.path));
         });

       }

     }catch (e) {
       print('Error picking image: $e');
     }
   }

   Future<void> uploadProduct() async {

     try {
       if(_productPriceTextController.text.isEmpty|| _productDescriptionTextController.text.isEmpty||_brandNameTextController.text.isEmpty||_colorTextController.text.isEmpty){
         Fluttertoast.showToast(msg: 'Please fill in all fields', gravity: ToastGravity.TOP);
         return;
       }
       String price = _productPriceTextController.text;
       if (price.isEmpty || double.tryParse(price) == null) {
         Fluttertoast.showToast(
           msg: 'Please enter a valid number for the product price',
           gravity: ToastGravity.TOP,
         );
         return;
       }
       if (productImages.length != 3) {
         // Display an error message if the condition is not met
         Fluttertoast.showToast(
           msg: 'Please select exactly three images', gravity: ToastGravity.TOP,
         );
         return;
       }


       setState(() {
         isUploading = true;
       });


       List<String> imageUrls = await uploadImagesToStorage(productImages);



       final String sellerID = FirebaseAuth.instance.currentUser!.email.toString();




       final productDoc = FirebaseFirestore.instance.collection("products")
           .doc();

       final productInfo = {
         'productName': _productnameTextController.text.toLowerCase(),
         'brandName': _brandNameTextController.text.toLowerCase(),
         'color': _colorTextController.text.toLowerCase(),
         'productDescription': _productDescriptionTextController.text,
         'productPrice': double.parse(_productPriceTextController.text),
        // 'productQuantity': int.parse(_productquantityTextController.text),
         'shoeSizes': _shoeSizeController.selectedOptions.map((item) =>
         item.label).toList(),
         'category': selectedValue ,
         // Ensure to handle null case appropriately
         'imageUrls': imageUrls,
         'sellerId': sellerID,
       };


       await productDoc.set(productInfo);

       setState(() {
         isUploading = false;
       });

       // Show success message
       // Fluttertoast.showToast(
       //   msg: 'Product uploaded successfully',
       //   gravity: ToastGravity.TOP,
       // );

       print('Image URLs: $imageUrls');
       print('Product uploaded successfully.');
       _notificationService.showNotification(
         id: 3,
         title: 'Update',
         body: 'Product added successfully.',

       );Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => AccountPage(),
         ),
       );


     }catch (e) {
       setState(() {
         isUploading = false;
       });

       // Show error message
       Fluttertoast.showToast(
         msg: 'Error uploading product: $e',
         gravity: ToastGravity.TOP,
       );

       print('Error uploading product: $e');
     }
   }

   Future<List<String>> uploadImagesToStorage(List<File> images) async {
     List<String> imageUrls = [];

     try {
       for (int i = 0; i < images.length; i++) {
         File image = images[i];


         String imagePath =
             'products/${DateTime.now().millisecondsSinceEpoch}/image_$i.jpg';


         UploadTask uploadTask =
         FirebaseStorage.instance.ref().child(imagePath).putFile(image);
         TaskSnapshot taskSnapshot = await uploadTask;


         String imageUrl = await taskSnapshot.ref.getDownloadURL();


         imageUrls.add(imageUrl);
       }
     } catch (e) {
       print('Error uploading images: $e');
     }

     return imageUrls;
   }



   Widget customimageField(int index, VoidCallback onPressed){
     TextEditingController _textEditingController = TextEditingController();

     return Container(
       width: 100,
       height: 100,
       decoration: BoxDecoration(
         color: Colors.deepPurple[100],
         borderRadius: BorderRadius.circular(8.0),

       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           GestureDetector(
             onTap: onPressed,
             child: Container(
               width: 100,
               height: 100,
               decoration: BoxDecoration(
                 color: Colors.deepPurple[200],
                 shape: BoxShape.circle,
               ),
               child: Center(
                 child: _pickedImages[index] != null
                     ? Image.file(
                   File(_pickedImages[index]!.path),
                   width: 100,
                   height: 100,
                   fit: BoxFit.fill,
                 )
                     : Icon(
                   Icons.add,
                   color: Colors.white,
                 ),
               ),
             ),
           ),
         ],

       ),
     );
   }


}

