  class cartModel{
    final String? name;
    final String? imageURL;
    final double? price;
    final int? quantitiy;
    final double? finalPrice;
    cartModel({required this.name, required this.imageURL,required this.price,required this.quantitiy,required this.finalPrice});

    cartModel.fromMap(Map<dynamic,dynamic> res)
    : name = res['name'],
          imageURL = res['imageURL'],
          price = res['price'],
          quantitiy = res['quantitiy'],
          finalPrice = res['finalPrice'];
    Map<String,Object?> toMap(){
      return{
        'name' : name,
        'imageURL' : imageURL,
        'price' : price,
        'quantity' : quantitiy,
        'finalPrice' : finalPrice,
      };
    }
  }
