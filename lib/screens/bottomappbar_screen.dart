import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:ebuzz/screens/activity_screen.dart';
import 'package:ebuzz/screens/home_screen.dart';
import 'package:ebuzz/screens/notification_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomappbarScreen extends StatefulWidget {
  BottomappbarScreen({Key key, this.title}) : super(key: key);
  static const String routeName = 'Bottomappber-screen';
  final String title;
  @override
  _BottomappbarScreenState createState() => _BottomappbarScreenState();
}

class _BottomappbarScreenState extends State<BottomappbarScreen> {
  int aindex = 0;
  final page = [
    HomeScreen(),
    NotificationScreen(),
    ActivityScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: page[aindex],
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFF8C0202),
            ),
          ),
          TabItem(
            icon: Icon(
              Icons.notifications,
              color: Color(0xFF8C0202),
            ),
          ),
          TabItem(
            icon: Icon(
              Icons.verified_user,
              color: Color(0xFF8C0202),
            ),
          ),
        ],
        backgroundColor: Color(0xFFF2F2F2),
        onTap: (index) {
          print(index);
          setState(() {
            aindex = index;
          });
        },
      ),
    );
  }
}
