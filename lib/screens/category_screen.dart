import 'package:flutter/material.dart';
import 'package:timegest/models/expenses.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  //listes de dépense
  late List<Expense> myExpenses;

  //listes de dépenses regoupées en catégory
  late Map<String, List<Expense>> categoryExp;

  void regroupement(
      Map<String, List<Expense>> categoryExp,
      List<Expense> myExpenses,
      ) {
    for (var action in myExpenses) {
      if (!categoryExp.keys.contains(action.cat)) {
        categoryExp.putIfAbsent(action.cat, () => [action]);
      } else {
        categoryExp[action.cat]!.add(action);
      }
    }
  }

  Future<void> _showMyDialog(Expense obj) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(obj.titre),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Montant :${obj.montant.toString()}"),
                Text("Réalisée le : ${obj.date.toString()}"),
                Text("Category : ${obj.cat}"),
                Text("Tag : ${obj.tag}"),
                Text("Motif : ${obj.motif}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    myExpenses = [
      Expense(
        id: 1,
        titre: "titre1",
        montant: 125,
        date: DateTime(0),
        cat: "cat1",
        tag: "tag1",
        motif: "motif1",
      ),
      Expense(
        id: 2,
        titre: "titre2",
        montant: 126,
        date: DateTime(0),
        cat: "cat2",
        tag: "tag2",
        motif: "motif2",
      ),
      Expense(
        id: 3,
        titre: "titre3",
        montant: 125,
        date: DateTime(0),
        cat: "cat1",
        tag: "tag1",
        motif: "motif4",
      ),
      Expense(
        id: 4,
        titre: "titre4",
        montant: 126,
        date: DateTime(0),
        cat: "cat2",
        tag: "tag3",
        motif: "motif3",
      ),
      Expense(
        id: 5,
        titre: "titre5",
        montant: 125,
        date: DateTime(0),
        cat: "cat1",
        tag: "tag1",
        motif: "motif5",
      ),
      Expense(
        id: 6,
        titre: "titre6",
        montant: 126,
        date: DateTime(0),
        cat: "cat5",
        tag: "tag3",
        motif: "motif3",
      ),
      Expense(
        id: 3,
        titre: "titre3",
        montant: 125,
        date: DateTime(0),
        cat: "cat1",
        tag: "tag1",
        motif: "motif4",
      ),
      Expense(
        id: 4,
        titre: "titre4",
        montant: 126,
        date: DateTime(0),
        cat: "cat2",
        tag: "tag3",
        motif: "motif3",
      ),
      Expense(
        id: 5,
        titre: "titre5",
        montant: 125,
        date: DateTime(0),
        cat: "cat1",
        tag: "tag1",
        motif: "motif5",
      ),
      Expense(
        id: 6,
        titre: "titre6",
        montant: 126,
        date: DateTime(0),
        cat: "cat5",
        tag: "tag3",
        motif: "motif3",
      ),
    ];
    categoryExp = {};

    regroupement(categoryExp, myExpenses);
    return ListView.builder(
      itemCount: categoryExp.length,
      itemBuilder: (context, index) {
        String categoty = categoryExp.keys.elementAt(index);
        List<Expense> items = categoryExp[categoty]!;
        return Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 20, bottom: 5),
              child: Text(
                categoty,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: items
                  .map(
                    (toElement) => InkWell(
                  splashColor: Colors.blueAccent.withOpacity(0.2),
                  onTap: (){
                    _showMyDialog(toElement);
                  },
                  child: ListTile(
                    title: Text(toElement.titre, style: TextStyle(fontSize: 18),),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.deepPurple,
                      onPressed: () {},
                    ),
                    subtitle: Text(toElement.date.toString(), style: TextStyle(fontStyle: FontStyle.italic),),
                    //titleTextStyle: TextStyle(fontSize: 14),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
