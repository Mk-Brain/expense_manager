import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/models/tag.dart';


class Tagmanagmentscreen extends StatefulWidget {
  const Tagmanagmentscreen({super.key});

  @override
  State<Tagmanagmentscreen> createState() => _TagmanagmentscreenState();
}

class _TagmanagmentscreenState extends State<Tagmanagmentscreen> {
  List<Tag> tagItems = [];


  Future<void>loaddata()async{
    final data = await context.watch<ExpenseProvider>().extract_tags();
    setState(() {
      tagItems = data;
    });
  }

  TextEditingController _tagController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loaddata();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Manage Tag"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("nouvelle tag"),
                  content: TextFormField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Annuler"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ExpenseProvider>().inser_tag(_tagController.text);
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }, icon: Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: tagItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tagItems[index].type),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.deepPurple),
                  onPressed: () {
                    context.read<ExpenseProvider>().delete_tag(tagItems[index].id);
                  },
                ),
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
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("nouvelle tag"),
                content: TextFormField(
                  controller: _tagController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Annuler"),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<ExpenseProvider>().inser_tag(_tagController.text);
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: Theme.of(context).primaryColor),
      ),*/
    );
  }
}
