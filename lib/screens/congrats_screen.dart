import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';

import 'package:ebuzz/screens/bottomappbar_screen.dart';
import 'package:ebuzz/widgets/widgets.dart';

// ignore: camel_case_types
class CongratsScreen extends StatefulWidget {
  static const String routeName = 'congrats-screen';
  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Center(
                  child: Column(
                    children: <Widget>[
                      CommonText(),
                      SizedBox(height: 40),
                      Commontitle(
                        'congrats!',
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Your account already to build",
                        style: TextStyle(color: grey, fontSize: 10),
                      ),
                      Icon(
                        Icons.check_circle,
                        size: 230,
                        color: primary,
                      ),
                      SizedBox(height: 110),
                      Container(
                        child: CommonButton(
                          child: Text('Home page '),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomappbarScreen()),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(child: Footer()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
