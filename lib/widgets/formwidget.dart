import 'package:flutter/material.dart';

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
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String ? _selectedCategoryValue;
  String ? _selectedTagValue;

  List<String> listCategory = ["famile", "transport", "facture"];
  List<String> TagList = ["un", "deux", "trois"];


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
      if (selectedDate != null) {
        _timeController.text = "${selectedTime!.hour}:${selectedTime!.minute}";
      }
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateController.text = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    _timeController.text = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
                      items: listCategory.map((String option){
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String ? newval){
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
                    items: TagList.map((String option){
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String ? newval){
                      setState(() {
                        _selectedTagValue = newval;
                      });
                    },
                    isExpanded: true,

                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
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
    );
  }
}
