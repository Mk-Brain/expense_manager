import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/data_base/categoryprovider.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/models/categories.dart';

class Categorymanagmentscreen extends StatefulWidget {
  const Categorymanagmentscreen({super.key});

  @override
  State<Categorymanagmentscreen> createState() => _CategorymanagmentscreenState();
}

class _CategorymanagmentscreenState extends State<Categorymanagmentscreen> {

  List<CategoryExpense> categoryItems = [];
  CategotyProvider cp = CategotyProvider();
  ExpenseProvider ep = ExpenseProvider();

  Future<void> opendb() async{
    Database db = await ep.openDataBase() ;
  }

  Future<void> loaddata() async{
    final data = await cp.extract_categories();
    setState(() {
      categoryItems = data;
    });
  }

  Future<void> deletedata(int id) async{
    cp.delete_category(id);
    setState(() {
      categoryItems.removeWhere((item)=>item.id == id);
    });
  }

  Future<void> adddata(String c) async{
    cp.inser_category(c);
    loaddata();
  }

  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState(){
    super.initState();
    opendb();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loaddata();
    //print(categoryItems);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);},),
        title: Text("Manage Category"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categoryItems[index].name),
                trailing: IconButton(icon:Icon(Icons.delete, color: Colors.deepPurple,), onPressed: (){
                  deletedata(categoryItems[index].id);
                },),
              );
            },
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
                return AlertDialog(

                  title: Text("nouvelle category"),
                  content: TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(5)
                        )
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Annuler")),
                    TextButton(onPressed: (){
                      adddata(_categoryController.text);
                      Navigator.pop(context);
                    }, child: Text("OK"))
                  ],
                );
              });
        },
        child: Icon(Icons.add, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
