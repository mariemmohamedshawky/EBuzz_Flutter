import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/notification_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.00,
        backgroundColor: primary,
        title: Text('Notification'),
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
            return Card(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        color: primary,
                        size: 20,
                      ),
                      Text(
                        '${emergency.date}',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
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
