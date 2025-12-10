//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:timegest/widgets/formwidget.dart';

class HomePage extends StatefulWidget {
  final String titre;
  const HomePage({required this.titre, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _currentselected = false;
  late final _tabController;
  late final AnimationController _animationController;



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(vsync: this, duration:const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: 1,
      length: 3,

      child: Scaffold(
        appBar: AppBar(
          elevation: 16,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text(
            widget.titre,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            controller: _tabController,
            enableFeedback: true,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 20),
            tabs: [
              Tab(text: "Category"),
              Tab(text: "Tag"),
              Tab(text: "Statistiques"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SafeArea(child: Center(child: Text("data1"))),
            SafeArea(child: Center(child: Text("data2"))),
            SafeArea(child: Center(child: Text("data3"))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            showModalBottomSheet(
              transitionAnimationController: _animationController,
              isScrollControlled: true,
              constraints: BoxConstraints.tight(
                Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
              ),
              context: context,
              builder: (BuildContext context) {
                return formAddExpense();
              },
            );
          },
          child: Icon(Icons.add),
        ),
        drawer: Drawer(
          backgroundColor: Colors.deepPurple,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Colors.white,
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: EdgeInsets.only(left: 100, top: 24, bottom: 24),
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                leading: Icon(Icons.category, color: Colors.white),
                title: Text(
                  "Category",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                selected: _currentselected,
                onTap: () {
                  setState(() {
                    _currentselected = !_currentselected;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.tag, color: Colors.white),
                title: Text(
                  "Tag",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                selected: _currentselected,
                onTap: () {
                  setState(() {
                    _currentselected = !_currentselected;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
