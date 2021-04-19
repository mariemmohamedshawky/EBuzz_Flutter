import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/activity_screen.dart';
import 'package:ebuzz/screens/home_screen.dart';
import 'package:ebuzz/screens/notification_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtomBarCommon extends StatelessWidget {
  ButtomBarCommon({this.onPressed});
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      items: [
        TabItem(
          icon: IconButton(
            icon: Icon(Icons.home),
            color: primary,
            onPressed: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            },
          ),
        ),
        TabItem(
          icon: IconButton(
            icon: Icon(Icons.notifications),
            color: primary,
            onPressed: () {
              Navigator.of(context).pushNamed(NotificationScreen.routeName);
            },
          ),
        ),
        TabItem(
          icon: IconButton(
            icon: Icon(Icons.verified_user),
            color: primary,
            onPressed: () {
              Navigator.of(context).pushNamed(ActivityScreen.routeName);
            },
          ),
        ),
      ],
      backgroundColor: secondary,
      onTap: onPressed,
    );
  }
}
