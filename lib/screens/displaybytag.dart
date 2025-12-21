import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/models/expenses.dart';

class Displaybytag extends StatefulWidget {
  const Displaybytag({super.key});

  @override
  State<Displaybytag> createState() => _DisplaybytagState();
}

class _DisplaybytagState extends State<Displaybytag> {

  //listes de dépense
  List<Expense> myExpenses = [];
  //dictionnaire de dépenses regoupées en catégory
  Map<String, List<Expense>> tagExp = {};


  Future<void> loaddata() async{
    final data = await context.watch<ExpenseProvider>().extract_expense();
    if(mounted) {
      setState(() {
        myExpenses = data;
      });
    }
  }


  void regroupement(
      Map<String, List<Expense>> tagExp,
      List<Expense> myExpenses,
      ) {
    for (var action in myExpenses) {
      if (!tagExp.keys.contains(action.tag)) {
        tagExp.putIfAbsent(action.tag, () => [action]);
      } else {
        tagExp[action.tag]!.add(action);
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
                Text("Réalisée le : ${obj.date}"),
                Text("Category : ${obj.category}"),
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
    loaddata();
    tagExp = {};
    regroupement(tagExp, myExpenses);
    return ListView.builder(
      itemCount: tagExp.length,
      itemBuilder: (context, index) {
        String tag = tagExp.keys.elementAt(index);
        List<Expense> items = tagExp[tag]!;
        return Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 20, bottom: 5),
              child: Text(
                tag,
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
                      onPressed: () {
                        context.read()<ExpenseProvider>().delete_expense(toElement.id);
                      },
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
