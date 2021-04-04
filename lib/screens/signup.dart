import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:ebuzz/screens/codepage.dart';

class Signuppage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Signuppage> {
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
                        'Create better together',
                        style: TextStyle(
                          color: HexColor("#0B090A"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 20),
                      Text(
                        "join our community",
                        style:
                            TextStyle(color: HexColor("#B1A7A6"), fontSize: 10),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
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
                            hintText: "Enter Number",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "We will send confirmation code",
                        style:
                            TextStyle(color: HexColor("#B1A7A6"), fontSize: 10),
                      ),
                      SizedBox(height: 225),
                      Container(
                        child: CommonButton(
                          child: Text('Continue '),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //hena hero7 3la page el code(new user)
                                  builder: (context) => Codepage()),
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
