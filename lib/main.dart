import 'package:flutter/material.dart';
import '../screens/home_page.dart';
void main() {
  runApp(const MyApp());
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
      theme: ThemeData(
        applyElevationOverlayColor: true,
      ),
      darkTheme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
