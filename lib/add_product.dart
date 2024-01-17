import 'package:flutter/material.dart';
import 'package:kickxx/reusable_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'product_images.dart';
class AddProduct extends StatelessWidget {
   AddProduct({super.key});
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



   final List<String> items = [
     'Nike Lifestyle',
     'Nike Jordan',
     'Nike Air Max',
     'Nike Air Force 1',
     'Nike Dunks & Blazers',
     'Nike Basketball',
     'Nike Running',
     'Nike Sandal & Slides',
   ];
   String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
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
                  controller: _controller,
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
                        _controller.clearAllSelection();
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
                        if (_controller.isDropdownOpen) {
                          _controller.hideDropdown();
                        } else {
                          _controller.showDropdown();
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
                      customimageField(),customimageField(),customimageField(),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:<Widget> [
                      customimageField(),customimageField(),customimageField(),
                    ],
                  ),],
                ),

                      
              ],
            ),
          ),
        ),
      ),
    );
  }
}

