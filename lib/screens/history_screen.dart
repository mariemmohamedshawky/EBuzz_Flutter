import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history-screen';
  HistoryScreen({Key key}) : super(key: key);
  final List<String> sampleList = <String>['', '', '', '', ''];

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'History',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                'Cancel',
                style: TextStyle(
                  color: HexColor("#B1A7A6"),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 50),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4.0,
                    child: Padding(
                      child: Text(
                        '${widget.sampleList[index]}',
                        style: TextStyle(fontSize: 10.0),
                      ),
                      padding: EdgeInsets.all(20.0),
                    ),
                  );
                },
                itemCount: widget.sampleList.length,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
