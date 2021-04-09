import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:ebuzz/screens/congrats_screen.dart';

class Codepage extends StatefulWidget {
  static const String routeName = 'codepage-screen';
  @override
  _State createState() => _State();
}

class _State extends State<Codepage> {
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
                        'Enter Code',
                        style: TextStyle(
                          color: HexColor("#0B090A"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 20),
                      Text(
                        "We Send it to the number",
                        style:
                            TextStyle(color: HexColor("#B1A7A6"), fontSize: 10),
                      ),
                      Container(
                        margin: EdgeInsets.all(70),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            hintText: "Code",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 160),
                      Container(
                        child: CommonButton(
                          child: Text('Continue'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //hena hro7 3la page congrats
                                  builder: (context) => CongratsScreen()),
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
