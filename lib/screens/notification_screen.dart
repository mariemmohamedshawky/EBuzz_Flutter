import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/notification_model.dart';
import 'package:ebuzz/providers/report.dart';
import 'package:ebuzz/screens/map_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification.dart' as notificationProvider;

class NotificationScreen extends StatefulWidget {
  //NotificationScreen({Key key}) : super(key: key);
  static const String routeName = 'notification-screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _isLoading = false;
  var _isInit = true;
  var _loadMore = true;
  int totalPages;
  List<NotificationModel> myNotifications = [];
  List<NotificationModel> myData = [];
  static int page = 1;
  ScrollController _scrollController = new ScrollController();
  final _reasonController = new TextEditingController();
  int emergencyReportedId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMore) {
          getNotifications(page);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getNotifications(1);
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

  Future<void> getNotifications(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      totalPages = await Provider.of<notificationProvider.Notification>(context,
              listen: false)
          .viewNotifications(index);
      myData =
          Provider.of<notificationProvider.Notification>(context, listen: false)
              .items;
      myNotifications.addAll(myData);
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
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

  void _submitReport(BuildContext ctx) async {
    if (_reasonController.text.isEmpty) {
      return;
    }
    try {
      var success = await Provider.of<Report>(context, listen: false)
          .report(emergencyReportedId, _reasonController.text);
      if (success) {
        Navigator.of(ctx).pop();
        WarningPopup.showWarningDialog(
            context, true, 'Report Sent Success To Admin', () {});
        _reasonController.text = '';
      } else {
        Navigator.of(ctx).pop();
        WarningPopup.showWarningDialog(
            context, false, 'SomeThing Went Wrong !=!', () {});
      }
    } catch (error) {
      print(error);
      Navigator.of(ctx).pop();
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        iconTheme: IconThemeData(color: grey),
        title: Padding(
          padding: const EdgeInsets.only(left: 0.1),
          child: Text(
            'Notification',
            style: TextStyle(color: black),
          ),
        ),

        // centerTitle: false,
      ),
      drawer: Container(
        width: 250,
        child: Drawer(
          child: Container(child: MyDrawer()),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: myNotifications.length,
        padding: EdgeInsets.symmetric(vertical: 18.0),
        itemBuilder: (BuildContext context, int index) {
          var emergency = myNotifications[index].emergency;
          if (index == myNotifications.length) {
            return _buildProgressIndicator();
          } else {
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(MapScreen.routeName, arguments: {
                  'latitude': emergency.latitude,
                  'longitude': emergency.longitude,
                });
              },
              child: Card(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(emergency.photo),
                        backgroundColor: primary,
                      ),
                      title: RichText(
                        text: TextSpan(
                            text: '${emergency.userName} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: primary),
                            children: [
                              TextSpan(
                                  text:
                                      'in danger near you in ${emergency.road} in ${emergency.city}  please help',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: black,
                                  )),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            label: Text(
                              'Report',
                              style: TextStyle(color: black, fontSize: 10),
                            ),
                            icon: Icon(
                              Icons.report_gmailerrorred_outlined,
                              color: primary,
                            ),
                            onPressed: () {
                              setState(() {
                                emergencyReportedId = emergency.id;
                              });
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Report User'),
                                  content: Container(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Resason',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        TextField(
                                          controller: _reasonController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Report'),
                                      onPressed: () async {
                                        _submitReport(ctx);
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Text(
                            '${emergency.date}',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
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
