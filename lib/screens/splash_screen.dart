import 'package:ebuzz/providers/user.dart';
import 'package:ebuzz/screens/bottomappbar_screen.dart';
import 'package:provider/provider.dart';

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
    final user = Provider.of<User>(context, listen: false);
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      if (user.isAuth) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            BottomappbarScreen.routeName, (Route<dynamic> route) => false);
      } else {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => OnBoardingScreen()));
      }
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
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/splash.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
