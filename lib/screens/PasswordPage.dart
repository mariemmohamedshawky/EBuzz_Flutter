import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:ebuzz/screens/moredata.dart';

class PasswordPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<PasswordPage> {
  bool passwordVisible = true;
  bool passwordVisible2 = true;

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
                      SizedBox(height: 60),
                      Commontitle(
                          child: Text(
                        'Enter Passward',
                        style: TextStyle(
                          color: HexColor("#0B090A"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 40),
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
                              hintText: "Password",
                              hintStyle: TextStyle(fontSize: 10),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: HexColor("#970C0F"),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              )),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordVisible,
                        ),
                      ),
                      SizedBox(height: 50),
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
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(fontSize: 10),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: HexColor("#970C0F"),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible2 = !passwordVisible2;
                                  });
                                },
                              )),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordVisible2,
                        ),
                      ),
                      SizedBox(height: 180),
                      Container(
                        child: CommonButton(
                          child: Text('Login    '),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //hena htro7 3la more date (old user)
                                  builder: (context) => MoreDataPage()),
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
