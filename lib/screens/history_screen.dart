import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/emergency_model.dart';
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
  var _isInit = true;
  var _loadMore = true;
  int totalPages;
  List<EmergencyModel> myEmergencies = [];
  List<EmergencyModel> myData = [];
  static int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMore) {
          getEmergencies(page);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      getEmergencies(1);
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getEmergencies(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      totalPages = await Provider.of<Emergency>(context, listen: false)
          .viewHistory(index);
      myData = Provider.of<Emergency>(context, listen: false).items;
      myEmergencies.addAll(myData);
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }

    setState(() {
      _isLoading = false;
      if (page == totalPages) {
        print('enought');
        _loadMore = false;
      } else {
        page++;
      }
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
        body: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: myEmergencies.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == myEmergencies.length) {
                    return _buildProgressIndicator();
                  } else {
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
                            '${myEmergencies[index].massageCount},, ${myEmergencies[index].notificationCount}, ${myEmergencies[index].road}, ${myEmergencies[index].city}, ${myEmergencies[index].country}, ${myEmergencies[index].state}, ${myEmergencies[index].countryCode} (${myEmergencies[index].latitude}, ${myEmergencies[index].longitude}), ${myEmergencies[index].date}',
                            style: TextStyle(fontSize: 10.0),
                          ),
                          padding: EdgeInsets.all(20.0),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
