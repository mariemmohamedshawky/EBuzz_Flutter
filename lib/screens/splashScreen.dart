import 'dart:async';
import '../screens/onboarding.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';

/*
  Author Amr Rudy
*/


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => onboarding()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (
        Scaffold(
          backgroundColor: primary,
          body: Center(
            child: Text(appName,style: TextStyle(color: third,fontSize: 50,fontWeight: FontWeight.bold),),
          ),
        )
    );
  }

}