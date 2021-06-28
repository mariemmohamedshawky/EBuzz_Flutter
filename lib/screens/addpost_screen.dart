import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddpostScreen extends StatefulWidget {
  static const String routeName = 'addpost-screen';
  @override
  _AddpostScreenState createState() => _AddpostScreenState();
}

class _AddpostScreenState extends State<AddpostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(6, 20, 6, 10),
                height: 30,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'please maintain ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: '  integrity  ',
                            style: TextStyle(
                                color: Color(0xFF8C0202),
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'and',
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                            text: '  honesty  ',
                            style: TextStyle(
                                color: Color(0xFF8C0202),
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '.')
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 15),
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 370,
                  color: secondary,
                  child: Column(
                    children: [
                      Wrap(children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(8),
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: Color(0xFF8C0202),
                                size: 22,
                              ),
                              Text(
                                "location",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 270,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 16, 16, 8),
                                child: Container(
                                  height: 55,
                                  child: Form(
                                    child: TextField(
                                      decoration: InputDecoration.collapsed(
                                        hintText: "Write Your post....",
                                        hintStyle: TextStyle(
                                          color: grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                height: 180,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadiusDirectional.circular(16.0),
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "https://cdn.questionpro.com/userimages/site_media/no-image.png")),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FloatingActionButton.extended(
                              backgroundColor: secondary,
                              elevation: 0,
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Color(0xFF8C0202),
                              ),
                              label: Text(
                                "photo",
                                style: TextStyle(
                                  color: Color(0xFF8C0202),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FloatingActionButton.extended(
                              backgroundColor: secondary,
                              elevation: 0,
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_location_alt_outlined,
                                color: Color(0xFF8C0202),
                              ),
                              label: Text(
                                "location",
                                style: TextStyle(
                                  color: Color(0xFF8C0202),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: Color(0xFF8C0202),
                  icon: Icon(Icons.post_add_outlined),
                  label: Text(
                    "Add post",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
