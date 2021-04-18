import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/contacts_screen.dart';
import 'package:ebuzz/widgets/bottom_bar.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import './profile_screen.dart';
import './splash_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int aindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        elevation: 00.0,
        title: CommonText(),
      ),
      drawer: Container(
        width: 250,
        child: Drawer(
          child: Container(child: MyDrawer()),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 70),
            Container(
              child: Row(children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        print('left button ');
                      });
                    },
                    child: Image.asset('assets/images/ebuzz.png'),
                  ),
                ),
              ]),
            ),
            // RaisedButton(
            //   onPressed: () async {
            //     await Provider.of<User>(context, listen: false).logout();
            //     Navigator.of(context).pushNamed(SplashScreen.routeName);
            //   },
            //   child: Text('Logout'),
            //   color: primary,
            //   textColor: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(100),
            //   ),
            //   padding: EdgeInsets.fromLTRB(90, 12, 90, 12),
            // ),
            // SeeContactsButton(),
          ],
        ),
      ),
      bottomNavigationBar: ButtomBarCommon(
        onPressed: (index) {
          print(index);
          setState(() {
            aindex = index;
          });
        },
      ),
    );
  }
}
