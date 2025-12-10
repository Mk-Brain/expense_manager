import 'package:flutter/material.dart';

class Categorymanagmentscreen extends StatefulWidget {
  const Categorymanagmentscreen({super.key});

  @override
  State<Categorymanagmentscreen> createState() => _CategorymanagmentscreenState();
}

class _CategorymanagmentscreenState extends State<Categorymanagmentscreen> {
  List<String> categoryItems = ["un", "deux", "trois"];
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text(categoryItems[index],),
                trailing: IconButton(icon:Icon(Icons.delete), onPressed: (){},),
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
