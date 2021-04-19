import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/contacts_screen.dart';
import 'package:ebuzz/screens/history_screen.dart';
import 'package:ebuzz/screens/massage_screen.dart';
import 'package:ebuzz/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        // margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Container(
            margin: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: grey,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1594616838951-c155f8d978a0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Amr Rudy",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Divider(
                  color: grey,
                  height: 25,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: 8.0,
      ),
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        },
        leading: Icon(
          Icons.person,
          color: grey,
        ),
        title: Text("  Profile"),
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.contact_phone,
          color: grey,
        ),
        title: Row(
          children: [
            SeeContactsButton(),
          ],
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(MassageScreen.routeName);
        },
        leading: Icon(
          Icons.message,
          color: grey,
        ),
        title: Text("  Message"),
      ),
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(HistoryScreen.routeName);
        },
        leading: Icon(
          Icons.history,
          color: grey,
        ),
        title: Text("  History"),
      ),
    ]);
  }
}
