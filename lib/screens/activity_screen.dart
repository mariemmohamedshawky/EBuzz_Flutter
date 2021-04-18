import 'package:ebuzz/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:ebuzz/constants/constant.dart';

class ActivityScreen extends StatefulWidget {
  static const String routeName = 'activity-screen';
  //ActivityScreen({Key key}) : super(key: key);

  //final String title;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List username = ["aya", "reem", "omar"];
  List cardinfo = [
    "first card info,first card info,first card info,first card info,first card info,first card info,first card info,first card info",
    "second card info,second card info,second card info",
    "third card info,third card info,third card info,third card info,third card info,"
  ];
  List images = [
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: grey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.1),
          child: Commontitle('Activity'),
        ),

        // centerTitle: false,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            child: Container(
              height: 170.0,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 2),
              child: Expanded(
                child: Card(
                  shadowColor: Color(0xFFf25757),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 6,
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(images[index])),
                              ),
                            ),
                            Container(
                              child: Text(
                                username[index] ?? 'default value',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 5, 3),
                              height: 95.0,
                              child: (Text(
                                cardinfo[index] ?? 'default value',
                              )),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 8, 8),
                              height: 70.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadiusDirectional.circular(16.0),
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(images[index])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: username.length,
      ),
      bottomNavigationBar: ButtomBarCommon(
        onPressed: (index) {
          print(index);
          setState(() {
            // aindex = index;
          });
        },
      ),
    );
  }
}
