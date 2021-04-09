import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import './massage_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile-screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Ptofile',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //hena htro7 3la more date (old user)
                      builder: (context) => MassageScreen()),
                );
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: HexColor("#B1A7A6"),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Text(
                          'Name',
                          style: TextStyle(
                              color: HexColor("#B1A7A6"), fontSize: 10),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                              color: HexColor("#B1A7A6"), fontSize: 10),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Text(
                          'Location',
                          style: TextStyle(
                              color: HexColor("#B1A7A6"), fontSize: 10),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                          ),
                          keyboardType: TextInputType.url,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Text(
                          'Date of birth',
                          style: TextStyle(
                              color: HexColor("#B1A7A6"), fontSize: 10),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Text(
                          'Gender',
                          style: TextStyle(
                              color: HexColor("#B1A7A6"), fontSize: 10),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                        child: Text(
                          'About',
                          style: TextStyle(
                              color: HexColor("#B1A7A6"), fontSize: 10),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#970C0F")),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
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
