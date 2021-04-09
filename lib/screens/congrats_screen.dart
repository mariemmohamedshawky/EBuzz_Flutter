import 'package:flutter/material.dart';
import 'package:ebuzz/screens/home_screen.dart';
import 'package:hexcolor/hexcolor.dart';
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
                          child: Text(
                        'congrats!',
                        style: TextStyle(
                          color: HexColor("#0B090A"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 30),
                      Text(
                        "Your account already to build",
                        style:
                            TextStyle(color: HexColor("#B1A7A6"), fontSize: 10),
                      ),
                      Icon(
                        Icons.check_circle,
                        size: 230,
                        color: HexColor("#970C0F"),
                      ),
                      SizedBox(height: 110),
                      Container(
                        child: CommonButton(
                          child: Text('Home page '),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //هنا هيودي علي صفحة congrats
                                  builder: (context) => HomeScreen()),
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
