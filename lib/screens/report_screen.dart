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
    List<double> expmonth,
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

    for (var toElement in myExpenses) {
      for(int i = 0; i < expmonth.length; i++){
        String x = toElement.date;
        String y = "/${i + 1}/";
        if(x.contains(y)){
          expmonth[i] += toElement.montant.toDouble();
        }
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

  LineChartBarData graphAnnuel(List<double> donnee) {
    List<FlSpot> point = [];
    // On commence à 1 pour Janvier jusqu'à 12 pour Décembre
    for(int i = 0; i < donnee.length; i++){
      point.add(FlSpot((i + 1).toDouble(), donnee[i]));
    }
    LineChartBarData listCoordonnee = LineChartBarData(
      spots: point,
      isCurved: true,
      color: Colors.blue,
      barWidth: 1,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
    );
    return listCoordonnee;
  }

  String dateFR(int num){
    switch(num){
      case 1: return 'Janvier';
      case 2: return 'Février';
      case 3: return 'Mars';
      case 4: return 'Avril';
      case 5: return 'Mai';
      case 6: return 'Juin';
      case 7: return 'Juillet';
      case 8: return 'Août';
      case 9: return 'Septembre';
      case 10: return 'Octobre';
      case 11: return 'Novembre';
      case 12: return 'Décembre';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final present = DateTime.now();
    if(present.isAfter(DateTime(DateTime.now().year, 12, 31)))
    {
      context.read<ExpenseProvider>().resertExpenseDB();
    }

    //listes de dépense
    List<Expense> myExpenses = context.watch<ExpenseProvider>().expense;
    //dictionnaire de dépenses regoupées en catégory
    Map<String, List<Expense>> categoryExp = {};
    //dictionnaire de dépenses regoupées en catégory
    Map<String, List<Expense>> tagExp = {};

    double total = 0;
    List<Map<String, dynamic>> donneeCamenbercat = [];
    List<Map<String, dynamic>> donneeCamenbertag = [];
    List<double> expMonth = List<double>.filled(12, 0);

    regroupement(tagExp, categoryExp, expMonth, myExpenses);
    total = totalDepenses(myExpenses);
    donneeCamenbercat = donneesCamanberCategorie(categoryExp, total);
    donneeCamenbertag = donneesCamanberCategorie(tagExp, total);


    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "Rapport de ${dateFR(DateTime.now().month)} ${DateTime.now().year}",
                style: TextStyle(
                  fontSize: 24,
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
            else ...[
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
                              sections: camenber(donneeCamenbercat),
                              centerSpaceRadius: 20,
                              sectionsSpace: 1,
                            ),
                          ),
                        ),
                      ),
                      // Légende
                      SizedBox(width: 150,
                        child: Container(margin: const EdgeInsets.only(top: 16),
                          child: ListView.builder(
                            itemCount: donneeCamenbercat.length,
                            itemBuilder: (context, index) {
                              final item = donneeCamenbercat[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: getColor(index, donneeCamenbercat.length),
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
                              sections: camenber(donneeCamenbertag),
                              centerSpaceRadius: 20,
                              sectionsSpace: 1,
                            ),
                          ),
                        ),
                      ),
                      // Légende
                      SizedBox(width: 150,
                        child: Container(margin: const EdgeInsets.only(top: 16),
                          child: ListView.builder(
                            itemCount: donneeCamenbertag.length,
                            itemBuilder: (context, index) {
                              final item = donneeCamenbertag[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: getColor(index, donneeCamenbertag.length),
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
              // Graphique linéaire
              SizedBox(
                height: 300, // Hauteur réduite pour mieux s'adapter
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.only(right: 16, top: 16),
                  color: Colors.blue.withOpacity(0.05),
                  child: LineChart(
                    LineChartData(
                      clipData: FlClipData.all(),
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          )
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 1 && index <= 12) {
                                // Affiche seulement la première lettre ou les 3 premières lettres du mois
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    dateFR(index).substring(0, 3),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            }
                          )
                        )
                      ),
                      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.3))),
                      minX: 1,
                      maxX: 12,
                      minY: 0,
                      lineBarsData: [graphAnnuel(expMonth)],
                    )
                  ),
                ),
              ),
              const SizedBox(height: 50), // Marge en bas
            ],
          ],
        ),
      ),
    );
  }
}
