import 'views/main_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.white54))),
      home: const MainView(title: 'Flutter Demo Home Page'),
    );
  }
}
