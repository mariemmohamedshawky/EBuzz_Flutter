import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/widgets/bottom_bar.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  //NotificationScreen({Key key}) : super(key: key);
  static const String routeName = 'notification-screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List a = ["reem", "aya", "omar", "mohamed", "hassan"];
  List b = [
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
  ];
  List c = [
    "this is the notification body not num 1 ",
    "this is the notification body not num 2 ",
    "this is the notification body not num 3 ",
    "this is the notification body not num 4 ",
    "this is the notification body not num 5 ",
  ];
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
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(b[index]),
              backgroundColor: primary,
            ),
            title: RichText(
              text: TextSpan(
                  text: '${a[index]} ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: black),
                  children: [
                    TextSpan(
                        text: c[index],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        )),
                  ]),
            ),
          ));
        },
        itemCount: a.length,
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
