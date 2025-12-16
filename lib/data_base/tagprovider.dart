import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/models/tag.dart';

class TagProvider{
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
          '''CREATE TABLE tags(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL
          )'''
      );

      db.insert('tags', {
        'type' : 'Urgent',
      });

      db.insert('tags', {
        'type' : 'Mensuel',

      });

      db.insert('tags', {
        'type' : 'Ponctuel',

      });

      db.insert('tags', {
        'type' : 'Essentiel',
      });

      db.insert('tags', {
        'type' : 'Personnel',

      });

      db.insert('tags', {
        'type' : 'Imprevus',
      });
    });
    return _database!;
  }*/

  Future<List<Tag>> extract_tags() async {
    final db = await openDatabase('bdExpensive.db',version: 1);
    List<Map<String, Object?>> expmap = await db.query('tags');
    List<Tag> tagobject = [];
    for (var action in expmap) {
      tagobject.add(Tag.fromJson(action));
    }
    return tagobject;
  }


  Future<void> delete_tag(int id) async{
    final db = await openDatabase('bdExpensive.db');
    await db.delete('tags', where: 'id = ?', whereArgs: [id] );
  }

  Future<void> inser_tag(String tag) async{
    final db = await openDatabase('bdExpensive.db');
    await db.insert('tags', {"type": tag});
  }

}