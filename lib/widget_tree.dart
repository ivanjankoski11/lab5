import 'package:flutter/material.dart';
import 'package:mis_lab3/auth.dart';
import 'package:mis_lab3/login.dart';
import 'package:mis_lab3/main.dart';

class WidgetTree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage(title: "Exams");
        } else {
          return LoginPage();
        }
      },
    );
  }
}
