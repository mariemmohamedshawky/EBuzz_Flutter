import 'package:flutter/material.dart';
import 'package:ebuzz/screens/profile.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ebuzz/widgets/widgets.dart';

// ignore: camel_case_types
class Congarts extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Congarts> {
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
                                  builder: (context) => Profile()),
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
