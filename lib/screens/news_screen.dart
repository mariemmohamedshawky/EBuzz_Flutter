import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = 'news-screen';
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List username = ["aya", "reem", "omar"];
  List time = ["4 hours", "4 hours", "4 hours"];
  List location = ["cairo government", "cairo government", "cairo government"];
  List cardinfo = [
    "first card info,first card info,first card info,first card info,first card info,first card info,first card info,first card info",
    "second card info,second card info,second card info",
    "third card info,third card info,third card info,third card info,third card info,"
  ];

  int index = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 2),
                child: Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Row(
                            children: [
                              Container(
                                width: 80.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "https://media.istockphoto.com/photos/young-woman-portrait-in-the-city-picture-id1009749608?k=6&m=1009749608&s=612x612&w=0&h=ckLkBgedCLmhG-TBvm48s6pc8kBfHt7Ppec13IgA6bo=")),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 8, 4),
                                      child: Text(
                                        username[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      time[index],
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Wrap(
                              children: [
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(25, 10, 25, 3),
                                    child: (Text(
                                      cardinfo[index],
                                      style: TextStyle(fontSize: 14),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 10, 25, 8),
                              height: 160.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadiusDirectional.circular(16.0),
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "https://www.novo-monde.com/app/uploads/2017/11/novo-map-banner-3.jpg")),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 40, 8),
                              child: Container(
                                child: (Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Color(0xFF8C0202),
                                      size: 24,
                                    ),
                                    Text(
                                      location[index],
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: username.length,
      ),
    );
  }
}
