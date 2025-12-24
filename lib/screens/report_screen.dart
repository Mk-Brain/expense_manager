import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:timegest/models/expenses.dart';
import 'package:timegest/data_base/expensiveprovider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  //listes de dépense
  List<Expense> myExpenses = [];
  //dictionnaire de dépenses regoupées en catégory
  Map<String, List<Expense>> categoryExp = {};
  //dictionnaire de dépenses regoupées en catégory
  Map<String, List<Expense>> tagExp = {};

  double totalDepenses = 0;

  List<Map<String, dynamic>> donneeCamenber = [];

  Future<void> loaddata() async {
    await context.read<ExpenseProvider>().extractExpenses(myExpenses);
    regroupement(categoryExp, tagExp, myExpenses);
    totalDepenses = total_depenses(myExpenses);
    donneeCamenber = donnees_camanber_categorie(categoryExp, totalDepenses);
  }

  void regroupement(
    Map<String, List<Expense>> tagExp,
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

    for (var action in myExpenses) {
      if (!tagExp.keys.contains(action.tag)) {
        tagExp.putIfAbsent(action.tag, () => [action]);
      } else {
        tagExp[action.tag]!.add(action);
      }
    }
  }

  double total_depenses(List<Expense> myExpenses) {
    double total = 0;
    for (var exp in myExpenses) {
      total += exp.montant;
    }
    return total;
  }

  List<Map<String, dynamic>> donnees_camanber_categorie(
    Map<String, List<Expense>> category_exp,
    double depensetotal,
  ) {
    final sizeofmap = category_exp.length;
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < sizeofmap; i++) {
      double totalcat = 0;
      String nom = category_exp.keys.elementAt(i);
      for (var x in category_exp[nom]!) {
        totalcat += x.montant;
      }
      double poucentage = (totalcat * 100) / depensetotal;
      Map<String, dynamic> elt = {'nom': nom, 'pourcentage': poucentage};
      data.add(elt);
    }
    return data;
  }

  List<PieChartSectionData> camenber(List<Map<String, dynamic>>donne){
    List<PieChartSectionData> listCamenber = [];
    for (var action in donne) {
            listCamenber.add(PieChartSectionData(
                value: action['pourcentage'],
                title: "${action['pourcentage']}%",
              titleStyle: TextStyle(color: Colors.white),
              radius: 60,
              color: Colors.blue
            ));
    }
    return listCamenber;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "date",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            SizedBox(
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 4),
                      spreadRadius: 2,
                      blurRadius: 16,
                    ),
                  ],
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      "Total des dépenses :",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "$totalDepenses FCFA",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 200,
                child: Container(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 150,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                              PieChartData(
                            sections: camenber(donneeCamenber)
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                              PieChartData(
                              sections: camenber(donneeCamenber)
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Container(color: Colors.blue, child: Text("graph")),
            ),
          ],
        ),
      ),
    );
  }
}
