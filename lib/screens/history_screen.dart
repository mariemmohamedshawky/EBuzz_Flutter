import 'package:ebuzz/components/maps/map_snapshot.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/emergency_model.dart';
import 'package:ebuzz/providers/emergency.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
      myData = Provider.of<Emergency>(context, listen: false).historyItems;
      myEmergencies.addAll(myData);
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
      return;
    }

    setState(() {
      _isLoading = false;
      if (page == totalPages) {
        print('end of lazy loading');
        _loadMore = false;
      } else {
        page++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: grey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          translator.translate(
            'history-tittle',
          ),
          style: TextStyle(
              color: black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
                  String mapsnap = MapSnapshot.generateLocationPreviewImage(
                      latitude: myEmergencies[index].latitude,
                      longitude: myEmergencies[index].longitude);
                  return Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Container(
                      height: 120,
                      child: Card(
                        shadowColor: black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 6,
                        child: Padding(
                          child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(mapsnap),
                                    fit: BoxFit.fitWidth,
                                    //alignment: Alignment.topCenter,
                                  ),
                                ),
                                width: 140,
                                height: 100,
                                child: Card(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${myEmergencies[index].road} ,${myEmergencies[index].state} ',
                                        style: TextStyle(
                                            fontSize: 5, color: primary),
                                      ),
                                    ],
                                  ),
                                  color: Colors.black.withOpacity(0),
                                  shadowColor: black,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.message,
                                        color: primary,
                                        size: 20,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                              text:
                                                  '${myEmergencies[index].massageCount}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text: translator.translate(
                                                'history-message',
                                              ),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            )
                                          ]))
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.notifications_active_outlined,
                                        color: primary,
                                        size: 20,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                              text:
                                                  '${myEmergencies[index].massageCount}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text: translator.translate(
                                                'history-not',
                                              ),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            )
                                          ]))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(20.0),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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
