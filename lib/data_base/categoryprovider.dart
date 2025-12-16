import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/models/categories.dart';

class CategotyProvider{
  static Database ? _database;


  /*Future<Database> openDataBase() async{
    //verrifier si la bd n'est pas deja ouverte
    if (_database != null) {
      return _database!;
    }
    //chemein vers la bd
    String databasespath = await getDatabasesPath();
    String path = join(databasespath, 'bdExpensive.db');
    //ouverture de la bd
    _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
      //activation des clés etrangères
      db.execute('PRAGMA foreign_keys = ON');
      await db.execute(
          '''CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
          )'''
      );
      db.insert('categories', {
        'name' : 'Transport',
      });

      db.insert('categories', {
        'name' : 'Alimentation',
      });

      db.insert('categories', {
        'name' : 'Logement',
      });

      db.insert('categories', {
        'name' : 'Santé',
      });

      db.insert('categories', {
        'name' : 'Education',
      });

      db.insert('categories', {
        'name' : 'Vêtements',
      });

      db.insert('categories', {
        'name' : 'Loisirs',
      });

      db.insert('categories', {
        'name' : 'Travail/Etudes',
      });

      db.insert('categories', {
        'name' : 'Epargne/Investissement',
      });

      db.insert('categories', {
        'name' : 'Aide/Cadeaux',
      });
    });
    return _database!;
  }*/

  Future<List<CategoryExpense>> extract_categories() async {
    final db = await openDatabase('bdExpensive.db',version: 1);
    List<Map<String, Object?>> expmap = await db.query('categories');
    if(expmap.isEmpty) {
      print("Liste vide");
    }
    List<CategoryExpense> expobject = [];
    for (var action in expmap) {
      expobject.add(CategoryExpense.fromJson(action));
    }
    if(expmap.isEmpty) {
      print("Liste obj vide");
    }
    return expobject;
  }


  Future<void> delete_category(int id) async{
    final db = await openDatabase('bdExpensive.db');
    await db.delete('categories', where: 'id = ?', whereArgs: [id] );
  }

  Future<void> inser_category(String cat) async{
    final db = await openDatabase('bdExpensive.db');
    await db.insert('categories', {"name": cat});
  }

}