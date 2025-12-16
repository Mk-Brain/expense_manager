import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/data_base/tagprovider.dart';
import 'package:timegest/models/tag.dart';


class Tagmanagmentscreen extends StatefulWidget {
  const Tagmanagmentscreen({super.key});

  @override
  State<Tagmanagmentscreen> createState() => _TagmanagmentscreenState();
}

class _TagmanagmentscreenState extends State<Tagmanagmentscreen> {
  List<Tag> tagItems = [];

  TagProvider tp = TagProvider();
  ExpenseProvider ep = ExpenseProvider();

  Future<void> opendb() async {
    Database db = await ep.openDataBase();
  }

  Future<void> loaddata() async {
    final data = await tp.extract_tags();
    setState(() {
      tagItems = data;
    });
  }

  Future<void> deletedata(int id) async {
    tp.delete_tag(id);
    setState(() {
      tagItems.removeWhere((item) => item.id == id);
    });
  }

  Future<void> adddata(String c) async {
    tp.inser_tag(c);
    loaddata();
  }

  TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    opendb();
  }

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
                    deletedata(tagItems[index].id);
                  },
                ),
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
                      print(_tagController);
                      adddata(_tagController.text);
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
      ),
    );
  }
}
