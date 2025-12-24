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

  double totalDepenses(List<Expense> myExpenses) {
    double total = 0;
    for (var exp in myExpenses) {
      total += exp.montant;
    }
    return total;
  }

  List<Map<String, dynamic>> donneesCamanberCategorie(
    Map<String, List<Expense>> categoryExp,
    double depensetotal,
  ) {
    final sizeofmap = categoryExp.length;
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < sizeofmap; i++) {
      double totalcat = 0;
      String nom = categoryExp.keys.elementAt(i);
      for (var x in categoryExp[nom]!) {
        totalcat += x.montant;
      }
      double poucentage = depensetotal > 0 ? (totalcat * 100) / depensetotal : 0;
      Map<String, dynamic> elt = {'nom': nom, 'pourcentage': poucentage};
      data.add(elt);
    }
    return data;
  }

  Color getColor(int index, int nbcat) {
    final hue = (360 / nbcat) * index;
    return HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  List<PieChartSectionData> camenber(List<Map<String, dynamic>> donnee) {
    final nbcat = donnee.length;
    List<PieChartSectionData> listCamenber = [];
    for (var action in donnee) {
      listCamenber.add(PieChartSectionData(
        value: action['pourcentage'],
        title: "${(action['pourcentage'] as double).toStringAsFixed(1)}%",
        color: getColor(donnee.indexOf(action), nbcat),
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        radius: 60,
      ));
    }
    return listCamenber;
  }


  @override
  Widget build(BuildContext context) {
    //listes de dépense
    List<Expense> myExpenses = context.watch<ExpenseProvider>().expense;
    //dictionnaire de dépenses regoupées en catégory
    Map<String, List<Expense>> categoryExp = {};
    //dictionnaire de dépenses regoupées en catégory
    Map<String, List<Expense>> tagExp = {};
    
    double total = 0;
    List<Map<String, dynamic>> donneeCamenber = [];
    
    regroupement(tagExp, categoryExp, myExpenses);
    total = totalDepenses(myExpenses);
    donneeCamenber = donneesCamanberCategorie(categoryExp, total);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "Rapport Mensuel",
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 4),
                      spreadRadius: 2,
                      blurRadius: 16,
                    ),
                  ],
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total des dépenses : ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "$total FCFA",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            
            if (myExpenses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("Aucune dépense enregistrée"),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      SizedBox(width: 150,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              sections: camenber(donneeCamenber),
                              centerSpaceRadius: 20,
                              sectionsSpace: 1,
                            ),
                          ),
                        ),
                      ),
                      // Légende
                      SizedBox(width: 150,
                        child: Container(margin: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                            itemCount: donneeCamenber.length,
                            itemBuilder: (context, index) {
                              final item = donneeCamenber[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: getColor(index, donneeCamenber.length),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${item['nom']}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            const SizedBox(height: 20),
            // Placeholder pour le graphe futur
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Container(
                color: Colors.blue.withOpacity(0.1), 
                child: const Center(child: Text("Graphique d'évolution (à venir)")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
