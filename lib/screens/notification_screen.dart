import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
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
  var myNotifications;
  int page = 2;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      getNotifications();
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  Future<void> getNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<notificationProvider.Notification>(context,
              listen: false)
          .viewNotifications(page);
      myNotifications =
          Provider.of<notificationProvider.Notification>(context, listen: false)
              .items;
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: myNotifications.length,
              itemBuilder: (BuildContext context, int index) {
                var emergency = myNotifications[index].emergency;
                return Card(
                    child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(emergency.photo),
                    backgroundColor: primary,
                  ),
                  title: RichText(
                    text: TextSpan(
                        text: '${emergency.userName} ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: black),
                        children: [
                          TextSpan(
                              text:
                                  '${emergency.road}, ${emergency.city}, ${emergency.country}, ${emergency.state}, ${emergency.countryCode} (${emergency.latitude}, ${emergency.longitude}), ${emergency.date}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              )),
                        ]),
                  ),
                ));
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
}
