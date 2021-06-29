import 'package:ebuzz/screens/bottomappbar_screen.dart';
import 'package:ebuzz/screens/myposts_screen.dart';
import 'package:ebuzz/screens/selected_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/constant.dart';
import '../providers/user.dart';
import '../screens/history_screen.dart';
import '../screens/massage_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
      child: Column(children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: grey,
                    child: CircleAvatar(
                        radius: 38,
                        backgroundImage:
                            NetworkImage(user.userData.photo ?? '')),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${user.userData.firstName} ${user.userData.lastName}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${user.userData.phone}',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Divider(
                    color: grey,
                    height: 20,
                    thickness: 2,
                    indent: 1,
                    endIndent: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(BottomappbarScreen.routeName);
          },
          leading: Icon(
            Icons.home,
            color: grey,
          ),
          title: Text("Home"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          },
          leading: Icon(
            Icons.person,
            color: grey,
          ),
          title: Text("Profile"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(SelectedContactsScreen.routeName);
          },
          leading: Icon(
            Icons.contact_phone,
            color: grey,
          ),
          title: Text("My Contact"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(MypostsScreen.routeName);
          },
          leading: Icon(
            Icons.podcasts_sharp,
            color: grey,
          ),
          title: Text("My Posts"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(MassageScreen.routeName);
          },
          leading: Icon(
            Icons.message,
            color: grey,
          ),
          title: Text("Message"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(HistoryScreen.routeName);
          },
          leading: Icon(
            Icons.history,
            color: grey,
          ),
          title: Text("History"),
        ),
        ListTile(
          onTap: () async {
            await Provider.of<User>(context, listen: false).logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
                SplashScreen.routeName, (Route<dynamic> route) => false);
          },
          leading: Icon(
            Icons.logout,
            color: grey,
          ),
          title: Text("Logout"),
        ),
      ]),
    ));
  }

  //Check contacts permission
  // ignore: unused_element
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.granted;
    } else {
      return permission;
    }
  }
}
