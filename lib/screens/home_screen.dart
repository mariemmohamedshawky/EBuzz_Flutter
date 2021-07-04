import 'dart:async';

import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/providers/emergency.dart';
import 'package:ebuzz/providers/user.dart';
import 'package:ebuzz/screens/call_screen.dart';
import 'package:ebuzz/screens/map_screen.dart';

import 'package:ebuzz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
  int aindex = 0;
  var _isLoading = false;
  Timer timer;

  Future<void> _getCurrentUserLocation() async {
    await [
      Permission.location,
    ].request();
    final locData = await location_package.Location().getLocation();

    try {
      await Provider.of<User>(context, listen: false)
          .updateLocation(locData.latitude, locData.longitude);
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }
  }

  Future<void> startEmergencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final emergencyId =
          await Provider.of<Emergency>(context, listen: false).startEmergency();
      if (emergencyId != 0 && emergencyId != false) {
        onJoin(emergencyId);
      } else {
        WarningPopup.showWarningDialog(
            context, false, 'SomeThing Went Wrong !=!', () {});
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // dispose input controller
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.all(5.0),
            title: Text(
              translator.translate(
                'home-notidication-alert-title',
              ),
              style: TextStyle(fontSize: 18),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  Icon(
                    Icons.notification_important,
                    color: primary,
                    size: 20,
                  ),
                  Text(
                    notification.title,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    notification.body,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  translator.translate(
                    'home-alert-oky',
                  ),
                  style: TextStyle(
                    color: primary,
                  ),
                ),
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
        iconTheme: IconThemeData(color: grey),
        centerTitle: true,
        backgroundColor: white,
        elevation: 00.0,
        title: CommonText(),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(SpeechScreen.routeName);
        //     },
        //     icon: Icon(Icons.mic_none),
        //   ),
        // ],
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
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ignore: missing_required_param

                      MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(() {
                            startEmergencies();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Image.asset('assets/images/EBUZZ BUTTON.png'),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      final locData =
                          await location_package.Location().getLocation();
                      Navigator.of(context)
                          .pushNamed(MapScreen.routeName, arguments: {
                        'latitude': locData.latitude,
                        'longitude': locData.longitude,
                      });
                    },
                    icon: Icon(
                      Icons.share_location_outlined,
                      size: 30,
                      color: primary,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> onJoin(var emergencyId) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          channelName: '$emergencyId' ?? 'test',
          role: ClientRole.Broadcaster,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }
}
