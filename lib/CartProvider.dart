import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cartProvider with ChangeNotifier{
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice =>_totalPrice;

  void _setPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter(){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter(){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter(){
    return _counter;
  }
  void addTotalPrice(double price){
    _totalPrice = _totalPrice + price;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double price){
    _totalPrice = _totalPrice - price;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice(){
    _setPrefItems();
    return _totalPrice;
  }

}