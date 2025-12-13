import 'package:timegest/models/categories.dart';

class Expense {
  final int id;
  final String titre;
  final num montant;
  final DateTime date;
  final String cat;
  final String tag;
  final String motif;

  Expense({
    required this.id,
    required this.titre,
    required this.montant,
    required this.date,
    required this.cat,
    required this.tag,
    required this.motif,
  });
  factory Expense.fromJSon(Map<String, dynamic> objetjson) {
    return Expense(
      id: objetjson['id'],
      titre: objetjson['titre'],
      montant: objetjson['montant'],
      date: DateTime.parse(objetjson['date']),
      cat: objetjson['cat'],
      tag: objetjson['tag'],
      motif: objetjson['motif'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'montant': montant,
      'date': date,
      'cat': cat,
      'tag' : tag,
      'motif' : motif
    };
  }
}
