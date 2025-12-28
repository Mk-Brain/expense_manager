import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:timegest/models/expenses.dart';
import 'package:timegest/models/categories.dart';
import 'package:timegest/models/tag.dart';

class ExpenseProvider with ChangeNotifier {
  static Database? _database;
  List<Expense> _expense = [];
  bool _isOpening = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await openDataBase();
  }

  Future<Database> openDataBase() async {
    if (_database != null) {
      return _database!;
    }
    
    if (_isOpening) {
      while (_database == null) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return _database!;
    }
    
    _isOpening = true;
    
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'bdExpensive.db');
      
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await _createTables(db, version);
        },
      );
    } finally {
      _isOpening = false;
    }
    
    return _database!;
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titre TEXT NOT NULL,
          montant REAL NOT NULL,
          date TEXT NOT NULL,
          category TEXT NOT NULL,
          tag TEXT NOT NULL,
          motif TEXT NOT NULL
          )''');

    await db.execute('''CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
          )''');

    await db.execute('''CREATE TABLE tags(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL
          )''');

    // Initial data insertion
    final categories = [
      'Transport', 'Alimentation', 'Logement', 'Santé', 'Education',
      'Vêtements', 'Loisirs', 'Travail/Etudes', 'Epargne/Investissement', 'Aide/Cadeaux'
    ];
    
    for (var cat in categories) {
      await db.insert('categories', {'name': cat});
    }

    final tags = [
      'Urgent', 'Mensuel', 'Ponctuel', 'Essentiel', 'Personnel', 'Imprevus'
    ];
    
    for (var tag in tags) {
      await db.insert('tags', {'type': tag});
    }
  }

  List<Expense> get expense => _expense;

  Future<void> loadExpense() async{
    final db = await database;
    List<Map<String, Object?>> expMap = await db.query('expenses');
    _expense.clear();
    for (var action in expMap) {
      _expense.add(Expense.fromJSon(action));
    }
    notifyListeners();
  }


  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    Map<String, dynamic> exp = expense.toJson();
    await db.insert('expenses', exp);
    await loadExpense();
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    await loadExpense();
    notifyListeners();
  }

  Future<void> resertExpenseDB() async {
    final db = await database;
    await db.execute('''DELETE FROM expenses''');
    await loadExpense();
    notifyListeners();
  }

  Future<void> updateExpense(int id, Map<String, dynamic> newData) async {
    final db = await database;
    await db.update('expenses', newData, where: 'id = ?', whereArgs: [id]);
    await loadExpense();
    notifyListeners();
  }

  Future<void> extractCategories(List<CategoryExpense> expObject) async {
    final db = await database;
    List<Map<String, Object?>> expMap = await db.query('categories');
    for (var action in expMap) {
      expObject.add(CategoryExpense.fromJson(action));
    }
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<void> insertCategory(String cat) async {
    final db = await database;
    await db.insert('categories', {"name": cat});
    notifyListeners();
  }

  Future<void> extractTags(List<Tag> tagObject) async {
    final db = await database;
    List<Map<String, Object?>> expMap = await db.query('tags');
    for (var action in expMap) {
      tagObject.add(Tag.fromJson(action));
    }
    notifyListeners();
  }

  Future<void> deleteTag(int id) async {
    final db = await database;
    await db.delete('tags', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<void> insertTag(String tag) async {
    final db = await database;
    await db.insert('tags', {"type": tag});
    notifyListeners();
  }
}
