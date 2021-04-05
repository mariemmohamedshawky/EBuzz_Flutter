import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';

/*
  Author Amr Rudy
*/

class SlideCell extends StatelessWidget {
  String image, title, subtitle;

  SlideCell(this.image, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      /*height: MediaQuery.of(context).size.height * 0.4,*/
      child: ListView(
        children: [
          Center(
            child: Image.asset(
              image,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.25,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              subtitle,
              style: TextStyle(color: grey),
            ),
          ),
        ],
      ),
    );
  }
}