import 'package:flutter/material.dart';
import 'package:todo_app/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      home: HomeScreen(),
    );
  }
}
