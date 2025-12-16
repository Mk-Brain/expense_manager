//import 'dart:io';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' ;
import 'package:timegest/models/expenses.dart';


class ExpenseProvider{
  static Database ? _database;

  Future<Database> openDataBase() async{
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
    });
    return _database!;
  }

  static Future _createtables(Database db, int version)async{
        await db.execute(
        '''CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titre TEXT NOT NULL,
          montant REAL NOT NULL,
          date TEXT NOT NULL,
          category TEXT NOT NULL,
          tag TEX NOT NULL,
          motif TEXT NOT NULL
          )'''
    );

        await db.execute(
            '''CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
          )'''
        );

        await db.execute(
            '''CREATE TABLE tags(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL
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
  }

  Future<List<Expense>> extract_expense() async {
    final db = await openDatabase('bdExpensive.db');
    List<Map<String, Object?>> expmap = await db.query('expenses');
    List<Expense> expobject = [];
    for (var action in expmap) {
      expobject.add(Expense.fromJSon(action));
    }
    return expobject;
  }

  Future<void> insert_expense(Expense expense) async{
    Map<String, dynamic> exp = expense.toJson();
    final db = await openDatabase('bdExpensive.db');
    await db.insert('expenses', exp);
  }

  Future<void> delete_expense(int id) async{
    final db = await openDatabase('bdExpensive.db');
    await db.delete('expenses', where: 'id = ?', whereArgs: [id] );
  }

  Future<void> update_expense(int id, Map<String, dynamic> new_data) async{
    final db = await openDatabase('bdExpensive.db');
    await db.update('expenses', new_data, where: 'id = ?', whereArgs: [id] );
  }
}