import 'package:flutter/material.dart';
import 'package:timegest/screens/displaybycategoty.dart';
import 'package:timegest/screens/categorymanagmentscreen.dart';
import 'package:timegest/screens/displaybytag.dart';
import 'package:timegest/screens/report_screen.dart';
import 'package:timegest/screens/tagmanagmentscreen.dart';
import 'package:timegest/widgets/formwidget.dart';

class HomePage extends StatefulWidget {
  final String titre;
  const HomePage({required this.titre, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //controlle de l'etat de selection du item de la tabBar
  bool _currentselected = false;
  late final _tabController;
  //controller de l'animation d'affichage de la bottom sheet
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4, // Réduit l'élévation pour un look plus moderne
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          widget.titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          enableFeedback: true,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          dividerColor: Colors.transparent,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), // Taille de police ajustée
          tabs: const [
            Tab(text: "Category"),
            Tab(text: "Tag"),
            Tab(text: "Statistiques"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          //affichage de la liste par category
          CategoryScreen(),
          //affichage de la liste par tag
          Displaybytag(),
          //afficher le rapport du mois
          ReportScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Utilisation des couleurs du thème
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        onPressed: () {
          //affichage de la bottom sheet
          showModalBottomSheet(
            transitionAnimationController: _animationController,
            isScrollControlled: true,
            useSafeArea: true, // Ajout de useSafeArea pour éviter les débordements
            constraints: BoxConstraints.tight(
              Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return const formAddExpense();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      //construction du drower
      drawer: Drawer(
        // Utilisation de la couleur de surface du thème
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //en-tête du drower
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            //corps du drower
            ListTile(
              leading: Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
              title: Text(
                "Category",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, 
                  fontSize: 18
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer avant de naviguer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Categorymanagmentscreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.tag, color: Theme.of(context).colorScheme.primary),
              title: Text(
                "Tag",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, 
                  fontSize: 18
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer avant de naviguer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Tagmanagmentscreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
