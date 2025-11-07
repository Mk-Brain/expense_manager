//import 'dart:io';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' ;
import 'package:timegest/models/expenses.dart';




class ExpensiveProvider{
  static Database ? _database;

  static Future<Database> _createDataBase() async{
    //verrifier si la bd n'est pas deja ouverte
    if (_database != null) {
      return _database!;
    }
    //chemein vers la bd
    String databasespath = await getDatabasesPath();
    String path = join(databasespath, 'bdExpensive.db');
    //ouverture de la bd
    _database = await openDatabase(path, version: 1, onCreate: (db, version){
      //activation des clés etrangères
      db.execute('PRAGMA foreign_keys = ON');
      _createtables(db, version);
      _insert_categories(db, version);
      _insert_tags(db, version);
    });
    return _database!;
  }

  static Future _createtables(Database db, int version)async{
    await db.execute(
      '''CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          )'''
    );

    await db.execute(
        '''CREATE TABLE tags(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          libelle TEXT NOT NULL,
          type TEXT NOT NULL
          )'''
    );

    await db.execute(
        '''CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titre TEXT NOT NULL,
          montant REAL NOT NULL,
          date TEXT NOT NULL,
          category_id INTEGER,
          tag_id INTEGER,
          motif TEXT NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories(id),
          FOREIGN KEY (tag_id) REFERENCES categories(id),
          )'''
    );
  }

  static Future _insert_categories(Database db, int version) async{
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
  }

  static Future _insert_tags(Database db, int version) async{
    db.insert('tags', {
      'type' : 'Urgent',
      'libelle' : 'depense importante dans un cour délais',
    });

    db.insert('tags', {
      'type' : 'Mensuel',
      'libelle' : 'depense revenant chaque mois',
    });

    db.insert('tags', {
      'type' : 'Ponctuel',
      'libelle' : 'depense n\'arrivant pas regulèrement',
    });

    db.insert('tags', {
      'type' : 'Essentiel',
      'libelle' : 'depense importante',
    });

    db.insert('tags', {
      'type' : 'Personnel',
      'libelle' : 'depense pour mon propre bien-être',
    });

    db.insert('tags', {
      'type' : 'Imprevus',
      'libelle' : 'depense non planifiée',
    });
  }

  static Future<List<Expense>> _extract_expense(Expense expense) async {
    final db = await openDatabase('bdExpensive.db');
    List<Map<String, Object?>> expmap = await db.query('expenses');
    List<Expense> expobject = [];
    for (var action in expmap) {
      expobject.add(Expense.fromJSon(action));
    }
    return expobject;
  }
  static Future<void> _inser_expense(Expense expense) async{
    Map<String, dynamic> exp = expense.toJson();
    final db = await openDatabase('bdExpensive.db');
    await db.insert('expenses', exp);
  }

  static Future<void> _delate_expense(int id) async{
    final db = await openDatabase('bdExpensive.db');
    await db.delete('expenses', where: 'id = ?', whereArgs: [id] );
  }

  static Future<void> _update_expense(int id, Map<String, dynamic> new_data) async{
    final db = await openDatabase('bdExpensive.db');
    await db.update('expenses', new_data, where: 'id = ?', whereArgs: [id] );
  }
}