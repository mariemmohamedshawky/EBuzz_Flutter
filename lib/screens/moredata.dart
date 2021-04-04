import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:ebuzz/screens/signup.dart';

class MoreDataPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MoreDataPage> {
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
                        'More Data',
                        style: TextStyle(
                          color: HexColor("#0B090A"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            hintText: "Full Name",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            hintText: "Location",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            hintText: "Adress",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ),
                      SizedBox(height: 110),
                      Container(
                        child: CommonButton(
                          child: Text('Continue'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  ////hena hro7 3la page congrats
                                  builder: (context) => Signuppage()),
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
