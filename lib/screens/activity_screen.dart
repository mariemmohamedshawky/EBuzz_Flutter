import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ebuzz/components/maps/map_snapshot.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/models/emergency_model.dart';
import 'package:ebuzz/providers/emergency.dart';
import 'package:ebuzz/screens/call_screen.dart';
import 'package:ebuzz/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
  static int page;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMore) {
          getEmergencies(page, false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'End Of Activation',
              style: TextStyle(color: black),
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: secondary,
          ));
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      page = 1;
      getEmergencies(1, false);
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

  Future<void> getEmergencies(int index, bool refresh) async {
    setState(() {
      _isLoading = true;
    });

    try {
      totalPages = await Provider.of<Emergency>(context, listen: false)
          .viewActivities(index);
      myData = Provider.of<Emergency>(context, listen: false).activityItems;
      if (index == 1) {
        myEmergencies = [];
        page = 1;
        _loadMore = true;
        myEmergencies.insertAll(0, myData);
      } else {
        myEmergencies.addAll(myData);
      }
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
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
            child: RefreshIndicator(
              onRefresh: () => getEmergencies(1, true),
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
                          //   height: 180,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 60,
                                      child: Card(
                                        child: myEmergencies[index].status == 0
                                            ? FloatingActionButton(
                                                onPressed: () {},
                                                child: Icon(
                                                  Icons.videocam_off_outlined,
                                                  color: primary,
                                                  size: 25,
                                                ),
                                                backgroundColor: white,
                                              )
                                            : FloatingActionButton(
                                                backgroundColor: primary,
                                                child: Icon(
                                                  Icons.videocam_outlined,
                                                  color: white,
                                                  size: 25,
                                                ),
                                                onPressed: () => onJoin(
                                                    myEmergencies[index].id),
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

  Future<void> onJoin(id) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          channelName: '$id' ?? 'test',
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
