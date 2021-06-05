import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/providers/emergency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history-screen';
  HistoryScreen({Key key}) : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _isLoading = false;

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  Future<void> getNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Emergency>(context, listen: false).viewHistory();
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final myEmergencies = Provider.of<Emergency>(context).items;
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
                                '${myEmergencies[index].road}, ${myEmergencies[index].city}, ${myEmergencies[index].country}, ${myEmergencies[index].state}, ${myEmergencies[index].countryCode} (${myEmergencies[index].latitude}, ${myEmergencies[index].longitude}), ${myEmergencies[index].date}',
                                style: TextStyle(fontSize: 10.0),
                              ),
                              padding: EdgeInsets.all(20.0),
                            ),
                          ),
                        );
                      },
                      itemCount: myEmergencies.length,
                    ),
                  ),
                ],
              ),
      ),
    ));
  }
}
