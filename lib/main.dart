import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/loginscreen.dart';

void main() {
  runApp(MyAppLaunchActivity());
}

class MyAppLaunchActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: LoginPage());
  }
}
