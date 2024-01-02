import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Page',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Image.network(
                    'https://www.kickgame.co.uk/cdn/shop/products/Air-Jordan-1-Low-CQ4277-001-Travis_1.png?v=1659088883',
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Sneaker Name : Travis Scott X Jordan 1 Mocha Low',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Price : \$ 250',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Quality : Brand New',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                      'Select Size',
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
                    items: List.generate(11, (index) => index + 38)
                        .map((size) => DropdownMenuItem<int>(
                      value: size,
                      child: Text(
                        '$size',
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
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.shopping_cart_sharp),
        onPressed: ()=>{},
        color: Colors.white,
      ),
    );
  }
}
