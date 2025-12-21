import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/models/categories.dart';

class Categorymanagmentscreen extends StatefulWidget {
  const Categorymanagmentscreen({super.key});

  @override
  State<Categorymanagmentscreen> createState() => _CategorymanagmentscreenState();
}

class _CategorymanagmentscreenState extends State<Categorymanagmentscreen> {

  List<CategoryExpense> categoryItems = [];


  final TextEditingController _categoryController = TextEditingController();

  Future<void>loaddata()async{
    final data = await context.watch<ExpenseProvider>().extract_categories();
    setState(() {
      categoryItems = data;
    });
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
        actions: [
          IconButton(onPressed: (){
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
                        context.read<ExpenseProvider>().inser_category(_categoryController.text);
                        Navigator.pop(context);
                      }, child: Text("OK"))
                    ],
                  );
                });
          }, icon: Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categoryItems[index].name),
                trailing: IconButton(icon:Icon(Icons.delete, color: Colors.deepPurple,),
                  onPressed: (){
                  context.read<ExpenseProvider>().delete_category(categoryItems[index].id);

                },),
              );
            },
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
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
                      context.read<ExpenseProvider>().inser_category(_categoryController.text);
                      Navigator.pop(context);
                    }, child: Text("OK"))
                  ],
                );
              });
        },
        child: Icon(Icons.add, color: Theme.of(context).primaryColor),
      ),*/
    );
  }
}
