import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'CartModel.dart';

class DatabaseHelper{
  static Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();
  }
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,'cart.db');
    var db = await openDatabase(path, version: 1,onCreate: _onCreate,);
    return db;
  }
  _onCreate(Database db, int version ) async{
    await db.execute('CREATE TABLE cart (name TEXT,imageURL TEXT,price DOUBLE,quantity INTEGER,final price DOUBLE)');
  }

  Future<cartModel> insert(cartModel cart)async{
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }
}