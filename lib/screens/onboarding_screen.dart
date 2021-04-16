import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/enter_phone_screen.dart';
import '../widgets/onboarding.dart';
import '../constants/constant.dart';

/*
  Author Amr Rudy
*/

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = 'onboarding-screen';
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  List<Widget> _list = <Widget>[
    new Center(
        child: new SlideCell(
            "assets/images/onboarding1.png",
            'You can add your mobile \nnumber and close people ',
            'EBUZZ app join now \n to help you & society')),
    new Center(
        child: new SlideCell(
            "assets/images/onboarding2.png",
            'Save your current location \n on map',
            'EBUZZ app will \nlocate your locatio ')),
    new Center(
        child: new SlideCell(
            "assets/images/onboarding3.png",
            'Update your message to \n get help with near people',
            'EBUZZ app will \nsave this message')),
  ];

  double _curr = 0;
  String locale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      body: ListView(
        children: [
          SizedBox(
            height: 120,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PageView(
              children: _list,
              scrollDirection: Axis.horizontal,
//              reverse: true,
//              physics: BouncingScrollPhysics(),
              controller: controller,
              onPageChanged: (num) {
                setState(() {
                  _curr = num.toDouble();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new DotsIndicator(
                        dotsCount: 3,
                        position: _curr,
                        decorator: DotsDecorator(
                          color: third,
                          // Inactive color
                          activeColor: primary,
                          spacing: const EdgeInsets.all(4.0),
                          size: Size.square(15.0),
                          activeSize: Size.square(15.0),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EnterPhoneScreen()));
              },
              child: Card(
                color: primary,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: primary, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                margin: EdgeInsets.all(15.0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: 'Roboto-medium',
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
