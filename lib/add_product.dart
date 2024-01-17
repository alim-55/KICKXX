import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'product_images.dart';
class AddProduct extends StatefulWidget {
   AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
   TextEditingController _productnameTextController= TextEditingController();

   TextEditingController _productPriceTextController= TextEditingController();

   TextEditingController _sellernameTextController= TextEditingController();

   TextEditingController _productquantityTextController= TextEditingController();

   TextEditingController _productDescriptionTextController= TextEditingController();

   TextEditingController _brandNameTextController= TextEditingController();

   TextEditingController _colorTextController= TextEditingController();

   FocusNode f1 =FocusNode();

   FocusNode f2 =FocusNode();

   FocusNode f3 =FocusNode();

   FocusNode f4 =FocusNode();

   FocusNode f5 =FocusNode();

   FocusNode f6 =FocusNode();

   FocusNode f7 =FocusNode();

   final MultiSelectController _controller = MultiSelectController();
   final MultiSelectController _shoeSizeController = MultiSelectController();

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
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.deepPurple,
          child: Padding(
            padding: EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reusableTextField("Enter Product name", Icons.pedal_bike, false, _productnameTextController,f1,f2,context,(){}),
                SizedBox(height: 10.0),
                reusableTextField("Enter Brand name", Icons.pedal_bike, false, _brandNameTextController,f2,f3,context,(){}),
                SizedBox(height: 10.0),
                reusableTextField("Enter Shoe Color", Icons.pedal_bike, false, _colorTextController,f3,f4,context,(){}),
                SizedBox(height: 10.0),
                reusableTextField("Enter Product Description", Icons.pedal_bike, false, _productDescriptionTextController,f4,f5,context,(){}),
                SizedBox(height: 10.0),
                reusableTextField("Enter Product Price", Icons.pedal_bike, false, _productPriceTextController,f5,f6,context,(){}),
                SizedBox(height: 10.0),
                reusableTextField("Enter Product's Quantity", Icons.pedal_bike, false, _productquantityTextController,f6,f7,context,(){}),
                SizedBox(height: 10.0),


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
                  hintColor: Colors.white,
                  hintFontSize: 14.0,
                  borderColor: Colors.transparent,
                  selectedOptionBackgroundColor:Colors.white70,
                  optionsBackgroundColor:Colors.deepPurple[100],

                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  borderRadius: 20.0,
                  fieldBackgroundColor:Colors.white.withOpacity(0.3),
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
                child: MultiSelectDropDown(
                  controller: _controller,
                  onOptionSelected: (List<ValueItem> selectedOptions) {},
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

                  //selectedOptionTextColor: Colors.white,

                  selectionType: SelectionType.single,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  borderRadius: 20.0,
                  fieldBackgroundColor:Colors.white.withOpacity(0.3),
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
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
       // if(_productPriceTextController.text.isEmpty||_sellernameTextController.text.isEmpty||_productquantityTextController.text.isEmpty||_productDescriptionTextController.text.isEmpty||_brandNameTextController.text.isEmpty||_colorTextController.text.isEmpty){
       //   Fluttertoast.showToast(msg: 'Please fill in all fields', gravity: ToastGravity.TOP);
       //   return;
       // }
       List<String> imageUrls = await uploadImagesToStorage(productImages);



       final String sellerID = FirebaseAuth.instance.currentUser!.email.toString();




       final productDoc = FirebaseFirestore.instance.collection("products")
           .doc();

       final productInfo = {
         'productName': _productnameTextController.text,
         'brandName': _brandNameTextController.text,
         'color': _colorTextController.text,
         'productDescription': _productDescriptionTextController.text,
         'productPrice': double.parse(_productPriceTextController.text),
         'productQuantity': int.parse(_productquantityTextController.text),
         'shoeSizes': _shoeSizeController.selectedOptions.map((item) =>
         item.label).toList(),
         'category': selectedValue ?? "",
         // Ensure to handle null case appropriately
         'imageUrls': imageUrls,
         'sellerId': sellerID,
       };


       await productDoc.set(productInfo);



       print('Image URLs: $imageUrls');
       print('Product uploaded successfully.');
     }catch (e) {
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

