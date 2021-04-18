import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ebuzz/constants/constant.dart';
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
          icon: Icon(
            Icons.home,
            color: primary,
          ),
        ),
        TabItem(
          icon: Icon(
            Icons.notifications,
            color: primary,
          ),
        ),
        TabItem(
          icon: Icon(
            Icons.beenhere_sharp,
            color: primary,
          ),
        ),
      ],
      backgroundColor: secondary,
      onTap: onPressed,
    );
  }
}
