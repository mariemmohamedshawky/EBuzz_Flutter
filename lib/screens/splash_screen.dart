import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: primary,
      body: TextButton(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appName,
                style: TextStyle(
                    color: third, fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        onPressed: () => Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => OnBoardingScreen())),
      ),
    ));
  }
}
