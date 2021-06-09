import 'dart:async';
import '../screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';

/*
  Author Amr Rudy
*/

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> opacity;
  AnimationController controller;

  @override
  initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => OnBoardingScreen()));
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Text(
          appName,
          style: TextStyle(
              color: third, fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}
