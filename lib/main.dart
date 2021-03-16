import 'package:flutter/material.dart';
import 'package:havruta_project/Globals.dart';
import 'package:havruta_project/Screens/Login1.dart';
import 'Screens/SignupScreen.dart';

void main() {
  // Initial the connection to the db
  Globals.db.connect();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    Globals.context = context;
    // Check if the user already connect => return Home()
    if (Globals.currentUser != null){
      // Go to Home()
    }
    // Otherwise, return Login1()
    return MaterialApp(
      home: Scaffold(
        body: Login1(),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => new MyApp(),
        '/signupScreen': (BuildContext context)=> new SignupScreen(),
      },
    );
  }
}