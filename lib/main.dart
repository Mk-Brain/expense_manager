import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:timegest/data_base/expensiveprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ExpenseProvider()..openDataBase(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final title_app = "Expense Tracker";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title_app,
      theme: ThemeData(applyElevationOverlayColor: true),
      darkTheme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(titre: title_app), //formAddExpense()
      },
    );
  }
}
