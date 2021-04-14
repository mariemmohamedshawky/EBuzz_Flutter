import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/contacts_screen.dart';
import 'package:ebuzz/screens/moredata_screen.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import './profile_screen.dart';
import './splash_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ProfileScreen.routeName);
                },
                child: Text('Profile'),
                color: primary,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100),
                ),
                padding: EdgeInsets.fromLTRB(90, 12, 90, 12),
              ),
              SizedBox(height: 50),
              RaisedButton(
                onPressed: () async {
                  await Provider.of<User>(context, listen: false).logout();
                  Navigator.of(context).pushNamed(SplashScreen.routeName);
                },
                child: Text('Logout'),
                color: primary,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100),
                ),
                padding: EdgeInsets.fromLTRB(90, 12, 90, 12),
              ),
              CommonButton(
                child: Text('More data'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoreDataScreen()),
                  );
                },
              ),
              SeeContactsButton(),
            ],
          ),
        ),
      ),
    );
  }
}
