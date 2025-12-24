import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timegest/data_base/expensiveprovider.dart';
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
  String? _selectedCategoryValue;
  String? _selectedTagValue;

  List<CategoryExpense> categoryItems = [];
  List<Tag> tagItems = [];

  List<DropdownMenuItem<String>> tagmenu = [];
  List<DropdownMenuItem<String>> catmenu = [];

  Future<void> loaddata() async {
    final prov = context.read<ExpenseProvider>();
    await prov.extractCategories(categoryItems);
    await prov.extractTags(tagItems);
    setState(() {
      tagmenu = createdropdowntagmenu();
      catmenu = createdropdowncategotymenu();
    });
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
        _dateController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      }
    });
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
    });
  }

  List<DropdownMenuItem<String>> createdropdowntagmenu() {
    List<DropdownMenuItem<String>> dropdown = [];
    for (var action in tagItems) {
      dropdown.add(DropdownMenuItem(
        value: action.type,
        child: Text(action.type),
      ));
    }
    return dropdown;
  }

  List<DropdownMenuItem<String>> createdropdowncategotymenu() {
    List<DropdownMenuItem<String>> dropdown = [];
    for (var action in categoryItems) {
      dropdown.add(DropdownMenuItem(
        value: action.name,
        child: Text(action.name),
      ));
    }
    return dropdown;
  }

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec la date/heure actuelle
    _dateController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    _timeController.text = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
    
    // Chargement des données après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loaddata();
    });
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
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                          labelText: 'Nom de la dépense',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                        labelText: 'Montant',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le montant';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          _amountValue = int.tryParse(val) ?? 0;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: _timeController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.timelapse),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                        labelText: 'Choisissez l\'heure',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Heure invalide';
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectedTime();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.date_range),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                        labelText: 'Choisissez la date',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date invalide';
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectedDate();
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: 'Catégorie',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12)),
                      hint: const Text("Choisir une catégorie"),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      value: _selectedCategoryValue,
                      items: catmenu,
                      onChanged: (newval) {
                        setState(() {
                          _selectedCategoryValue = newval;
                        });
                      },
                      isExpanded: true,
                      validator: (value) =>
                          value == null ? 'Veuillez choisir une catégorie' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: 'Tag',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12)),
                      hint: const Text("Choisir un tag"),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      value: _selectedTagValue,
                      items: tagmenu,
                      onChanged: (newval) {
                        setState(() {
                          _selectedTagValue = newval;
                        });
                      },
                      isExpanded: true,
                      validator: (value) =>
                          value == null ? 'Veuillez choisir un tag' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _expenseDescriptionController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                          labelText: 'Description',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async{
                        if (_formkey.currentState!.validate()) {
                          final date =
                              "${_dateController.text} (${_timeController.text})";
                          Expense exp = Expense(
                            id: 0, // L'ID sera auto-incrémenté par la BD
                            titre: _expenseNameController.text,
                            date: date,
                            montant: _amountValue,
                            category: _selectedCategoryValue!,
                            tag: _selectedTagValue!,
                            motif: _expenseDescriptionController.text,
                          );
                          await context.read<ExpenseProvider>().insertExpense(exp);
                          //context.read<ExpenseProvider>().chexkChange();
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
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
