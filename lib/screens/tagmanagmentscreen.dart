import 'package:flutter/material.dart';

class Tagmanagmentscreen extends StatefulWidget {
  const Tagmanagmentscreen({super.key});

  @override
  State<Tagmanagmentscreen> createState() => _TagmanagmentscreenState();
}

class _TagmanagmentscreenState extends State<Tagmanagmentscreen> {
  List<String> tagItems = ["un", "deux", "trois"];
  TextEditingController _tagController = TextEditingController();
  
  @override
  void dispose() {
    // TODO: implement dispose
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);},),
        title: Text("Manage Tag"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: tagItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(tagItems[index],),
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

              title: Text("nouvelle tag"),
              content: TextFormField(
                controller: _tagController,
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
