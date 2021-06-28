import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/components/maps/map_snapshot.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/models/emergency_model.dart';
import 'package:ebuzz/providers/emergency.dart';
import 'package:ebuzz/screens/call_screen.dart';
import 'package:ebuzz/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  static const String routeName = 'activity-screen';
  //ActivityScreen({Key key}) : super(key: key);

  //final String title;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  var _isLoading = false;
  var _isInit = true;
  var _loadMore = true;
  int totalPages;
  List<EmergencyModel> myEmergencies = [];
  List<EmergencyModel> myData = [];
  static int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMore) {
          getEmergencies(page);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getEmergencies(1);
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getEmergencies(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      totalPages = await Provider.of<Emergency>(context, listen: false)
          .viewActivities(index);
      myData = Provider.of<Emergency>(context, listen: false).activityItems;
      myEmergencies.addAll(myData);
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
      return;
    }

    setState(() {
      _isLoading = false;
      if (page == totalPages) {
        print('end of lazy loading');
        _loadMore = false;
      } else {
        page++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: myEmergencies.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == myEmergencies.length) {
                  return _buildProgressIndicator();
                } else {
                  String mapsnap = MapSnapshot.generateLocationPreviewImage(
                      latitude: myEmergencies[index].latitude,
                      longitude: myEmergencies[index].longitude);
                  return Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(MapScreen.routeName, arguments: {
                          'latitude': myEmergencies[index].latitude,
                          'longitude': myEmergencies[index].longitude,
                        });
                      },
                      child: Container(
                        // height: 260,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(mapsnap),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: Card(
                          color: Colors.black.withOpacity(0),
                          shadowColor: black,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          //  elevation: 6,

                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print('profile');
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        minRadius: 25,
                                        maxRadius: 25,
                                        backgroundImage: NetworkImage(
                                          '${myEmergencies[index].photo}',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${myEmergencies[index].userName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${myEmergencies[index].road} ,${myEmergencies[index].state} ',
                                  style: TextStyle(fontSize: 6, color: primary),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/3.jpg"),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    width: 140,
                                    height: 90,
                                    child: Card(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.live_tv_rounded,
                                          color: primary,
                                          size: 25,
                                        ),
                                        onPressed: () =>
                                            onJoin(myEmergencies[index].phone),
                                      ),
                                      color: Colors.black.withOpacity(0),
                                      shadowColor: black,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> onJoin(phone) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          channelName: phone ?? 'test',
          role: ClientRole.Audience,
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
