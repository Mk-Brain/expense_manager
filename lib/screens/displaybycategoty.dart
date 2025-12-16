import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/models/expenses.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  //listes de dépense
  List<Expense> myExpenses = [];
  //dictionnaire de dépenses regoupées en catégory
  Map<String, List<Expense>> categoryExp = {};

  ExpenseProvider ep = ExpenseProvider();

  Future<void> opendb() async{
    Database db = await ep.openDataBase() ;
  }

  Future<void> loaddata() async{
    final data = await ep.extract_expense();
    if(mounted) {
      setState(() {
      myExpenses = data;
    });
    }
  }

  Future<void> deletedata(int id) async{
    ep.delete_expense(id);
    setState(() {
      myExpenses.removeWhere((item)=>item.id == id);
    });
  }

  Future<void> adddata(Expense e) async{
    ep.insert_expense(e);
    loaddata();
  }


  @override
  void initState(){
    super.initState();
    opendb();
  }



  void regroupement(
      Map<String, List<Expense>> categoryExp,
      List<Expense> myExpenses,
      ) {
    for (var action in myExpenses) {
      if (!categoryExp.keys.contains(action.category)) {
        categoryExp.putIfAbsent(action.category, () => [action]);
      } else {
        categoryExp[action.category]!.add(action);
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
                      onPressed: () {
                        deletedata(toElement.id);
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
