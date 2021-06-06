import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/emergency_model.dart';
import 'package:ebuzz/models/notification_model.dart';
import 'package:ebuzz/widgets/bottom_bar.dart';
import 'package:ebuzz/widgets/widgets.dart';
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
    // TODO: implement didChangeDependencies
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
        print('enought');
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
            color: grey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.00,
        backgroundColor: white,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.1),
          child: Commontitle('Notification'),
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
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(emergency.photo),
                  backgroundColor: primary,
                ),
                title: RichText(
                  text: TextSpan(
                      text: '${emergency.userName} ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: black),
                      children: [
                        TextSpan(
                            text:
                                '${emergency.road}, ${emergency.city}, ${emergency.country}, ${emergency.state}, ${emergency.countryCode} (${emergency.latitude}, ${emergency.longitude}), ${emergency.date}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            )),
                      ]),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: ButtomBarCommon(
        onPressed: (index) {
          print(index);
          setState(() {
            // aindex = index;
          });
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
