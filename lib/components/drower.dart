import 'package:permission_handler/permission_handler.dart';

import '../constants/constant.dart';
import '../providers/user.dart';
import '../screens/contacts_screen.dart';
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
                    backgroundImage: NetworkImage(user.userData.photo),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${user.userData.firstName} ${user.userData.lastName}',
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
        onTap: () async {
          final PermissionStatus permissionStatus = await _getPermission();
          if (permissionStatus == PermissionStatus.granted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactsScreen()));
          } else {
            if (await Permission.contacts.request().isGranted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactsScreen()));
            }
          }
        },
        leading: Icon(
          Icons.contact_phone,
          color: grey,
        ),
        title: Text("  Contact"),
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
      ListTile(
        onTap: () async {
          await Provider.of<User>(context, listen: false).logout();
          Navigator.of(context).pushNamed(SplashScreen.routeName);
        },
        leading: Icon(
          Icons.logout,
          color: grey,
        ),
        title: Text("  Logout"),
      ),
    ]);
  }

  //Check contacts permission
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
