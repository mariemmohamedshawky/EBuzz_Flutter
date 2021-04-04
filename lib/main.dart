import 'package:flutter/material.dart';
import 'package:ebuzz/screens/PasswordPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PasswordPage(),
        routes: <String, WidgetBuilder>{
          '/PasswordPage': (BuildContext context) => new PasswordPage(),
          //'/MoreDataPage': (BuildContext context) => new MoreDataPage(),
        });
  }
}
