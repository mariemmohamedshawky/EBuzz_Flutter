import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history-screen';
  HistoryScreen({Key key}) : super(key: key);
  final List<String> sampleList = <String>[
    "first card info,first card info,first card info,first card info,first card info,first card info,first card info,first card info",
    "second card info,second card info,second card info second card info,second card info,second cari,nfo",
    "second card info,second card info,second card info second card info,second card info,second card info",
    "third card info,third card info,third card info,third card info,third card info,"
  ];

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
                'Cancel',
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
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 120,
                    child: Card(
                      shadowColor: Color(0xFFf25757),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 6,
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        child: Text(
                          '${widget.sampleList[index]}',
                          style: TextStyle(fontSize: 10.0),
                        ),
                        padding: EdgeInsets.all(20.0),
                      ),
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
