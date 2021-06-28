import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/news_screen.dart';
import 'package:ebuzz/screens/activity_screen.dart';
import 'package:ebuzz/screens/addpost_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabbarScreen extends StatefulWidget {
  TabbarScreen({Key key, this.title}) : super(key: key);
  static const String routeName = 'Tabbar-screen';
  final String title;
  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: grey),
          title: const Text(
            'Activity',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            indicatorWeight: 3,
            labelColor: Color(0xFF8C0202),
            indicatorColor: Color(0xFF8C0202),
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Live",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Tab(
                child: Text(
                  "News",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Tab(
                child: Text(
                  "Add post",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        drawer: Container(
          width: 250,
          child: Drawer(
            child: Container(child: MyDrawer()),
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new ActivityScreen(),
            new NewsScreen(),
            new AddpostScreen(),
          ],
        ),
      ),
    );
  }
}
