import 'package:timegest/models/categories.dart';

class Expense {
  final int id;
  final String titre;
  final num montant;
  final DateTime date;
  final int category_id;
  final int tag_id;
  final String motif;

  Expense({
    required this.id,
    required this.titre,
    required this.montant,
    required this.date,
    required this.category_id,
    required this.tag_id,
    required this.motif,
  });
  factory Expense.fromJSon(Map<String, dynamic> objetjson) {
    return Expense(
      id: objetjson['id'],
      titre: objetjson['titre'],
      montant: objetjson['montant'],
      date: DateTime.parse(objetjson['date']),
      category_id: objetjson['category_id'],
      tag_id: objetjson['tag_id'],
      motif: objetjson['motif'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'montant': montant,
      'date': date,
      'categorie': category_id,
      'tag_ig' : tag_id,
      'motif' : motif
    };
  }
}
