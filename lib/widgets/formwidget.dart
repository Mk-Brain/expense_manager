import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timegest/data_base/categoryprovider.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
import 'package:timegest/data_base/tagprovider.dart';
import 'package:timegest/models/categories.dart';
import 'package:timegest/models/expenses.dart';
import 'package:timegest/models/tag.dart';

class formAddExpense extends StatefulWidget {
  const formAddExpense({super.key});

  @override
  State<formAddExpense> createState() => _formAddExpenseState();
}

class _formAddExpenseState extends State<formAddExpense> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _expenseNameController = TextEditingController();
  var _amountValue = 0;
  final TextEditingController _expenseDescriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String ? _selectedCategoryValue;
  String ? _selectedTagValue;

  ExpenseProvider ep = ExpenseProvider();
  List<CategoryExpense> categoryItems = [];
  CategotyProvider cp = CategotyProvider();
  List<Tag> tagItems = [];
  TagProvider tp = TagProvider();

  Future<void> opendb() async{
    Database db = await ep.openDataBase() ;
  }

  Future<void> adddata(Expense e) async{
    ep.insert_expense(e);
  }



  Future<void> loaddata() async{
    final cat = await cp.extract_categories();
    if(mounted) {
      setState(() {
      categoryItems = cat;
    });
    }
    final tag = await tp.extract_tags();
    if(mounted) {
      setState(() {
      tagItems = tag;
    });
    }
  }


  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      initialDate: DateTime.now(),
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2054),
    );
    setState(() {
      selectedDate = pickedDate;
      if (selectedDate != null) {
        _dateController.text = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      }
    }
    );
  }

  Future<void> _selectedTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    setState(() {
      selectedTime = pickedTime;
      if (selectedTime != null) {
        _timeController.text = "${selectedTime!.hour}:${selectedTime!.minute}";
      }
    }
    );
  }

  List<DropdownMenuItem> createdropdowntagmenu(){
    List<DropdownMenuItem> dropdown = [];
    for (var action in tagItems) {
      dropdown.add(DropdownMenuItem(value: action.type, child: Text(action.type),));
    }
    return dropdown;
  }

  List<DropdownMenuItem> createdropdowncategotymenu(){
    List<DropdownMenuItem> dropdown = [];
    for (var action in categoryItems) {
      dropdown.add(DropdownMenuItem(value: action.name, child: Text(action.name),));
    }
    return dropdown;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    opendb();
    _dateController.text = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    _timeController.text = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    _expenseDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loaddata();
    final tagmenu = createdropdowntagmenu();
    final catmenu = createdropdowncategotymenu();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _expenseNameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                        labelText: 'nom de la depence',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'veuillez entre un nom';
                        }
                        else {
                          return null;
                        }
                      }
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                          ),
                          labelText: 'montant',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'veuillez le montant';
                          }
                          else {
                            return null;
                          }
                        },
                      onChanged: (val){
                          _amountValue = int.parse(val);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: _timeController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.timelapse),
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                        labelText: 'Choisissez l\'heure',
          
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'heure invalide';
                        }
                        else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectedTime();
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                        labelText: 'Choisissez la date',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'date invalide';
                        }
                        else {
                          return null;
                        }
                      },
          
                      onTap: (){
                        _selectedDate();
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: 'category',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12)
                        ),
                        hint: Text("choisir une categorie"),
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        initialValue: _selectedCategoryValue,
                        items: catmenu,
                        onChanged: (newval){
                          setState(() {
                            _selectedCategoryValue = newval;
                          });
                        },
                      isExpanded: true,
                        ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: 'Tag',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12)
                      ),
                      hint: Text("choisir un tag"),
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      initialValue: _selectedTagValue,
                      items: tagmenu,
                      onChanged: (newval){
                        setState(() {
                          _selectedTagValue = newval;
                        });
                      },
                      isExpanded: true,
          
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _expenseDescriptionController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                          ),
                          labelText: 'description',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'description';
                          }
                          else {
                            return null;
                          }
                        }
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final date = "${_dateController.text} (${_timeController.text})";
                        Expense exp = Expense(
                            id: 1,
                            titre: _expenseNameController.text,
                            date: date,
                            montant: _amountValue,
                            category: _selectedCategoryValue!,
                            tag: _selectedTagValue!,
                            motif: _expenseDescriptionController.text,);
                        adddata(exp);
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        "Enregistrer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
