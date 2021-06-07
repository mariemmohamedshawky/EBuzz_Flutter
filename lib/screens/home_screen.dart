import 'dart:async';

import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/providers/user.dart';
import 'package:ebuzz/screens/call_screen.dart';
import 'package:ebuzz/widgets/bottom_bar.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location_package;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final user;
  static const String routeName = 'home-screen';
  HomeScreen({Key key, this.title, this.user}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole _role = ClientRole.Broadcaster;
  int aindex = 0;
  var _isLoading = false;
  Timer timer;

  Future<void> _getCurrentUserLocation() async {
    await [
      Permission.location,
    ].request();
    final locData = await location_package.Location().getLocation();

    print(locData.latitude);
    print(locData.longitude);

    try {
      var success = await Provider.of<User>(context, listen: false)
          .updateLocation(locData.latitude, locData.longitude);
      if (success) {
        print(success);
      } else {
        print(success);
      }
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _updateFcm() async {
    String token = await FirebaseMessaging.instance.getToken();
    print('token:$token');
    setState(() {
      Provider.of<User>(context, listen: false).updateFCMToken(token);
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => _getCurrentUserLocation());
    _updateFcm();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('New Notification!!'),
            content: Container(
              height: 50,
              child: Column(
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(notification.body),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          controller: _channelController,
                          decoration: InputDecoration(
                            errorText: _validateError
                                ? 'Channel name is mandatory'
                                : null,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            hintText: 'Channel name',
                          ),
                        ))
                      ],
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: Text(ClientRole.Broadcaster.toString()),
                          leading: Radio(
                            value: ClientRole.Broadcaster,
                            groupValue: _role,
                            onChanged: (ClientRole value) {
                              setState(() {
                                _role = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(ClientRole.Audience.toString()),
                          leading: Radio(
                            value: ClientRole.Audience,
                            groupValue: _role,
                            onChanged: (ClientRole value) {
                              setState(() {
                                _role = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    TextButton.icon(
                      onPressed: _getCurrentUserLocation,
                      icon: Icon(Icons.location_on),
                      label: Text('Current Location'),
                    ),
                    Container(
                      child: Row(children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                onJoin();
                              });
                            },
                            child: Image.asset('assets/images/ebuzz.png'),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
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

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }
}
