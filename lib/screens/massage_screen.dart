import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/history_screen.dart';
import 'package:flutter/material.dart';

class MassageScreen extends StatefulWidget {
  static const String routeName = 'masssage-screen';
  @override
  _MassageScreenState createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {
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
            'Massege',
            style: TextStyle(
                color: black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: grey,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 250,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Write Your own Message",
                      hintStyle: TextStyle(
                        color: grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              child: Text("This is your message that send to",
                  style: TextStyle(
                    fontSize: 12,
                    color: grey,
                  )),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Conacts',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),
                  children: [
                    TextSpan(
                      text: ' To get  ',
                      style: TextStyle(
                        fontSize: 15,
                        color: grey,
                      ),
                    ),
                    TextSpan(
                      text: 'help',
                      style: TextStyle(
                        fontSize: 15,
                        color: primary,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
