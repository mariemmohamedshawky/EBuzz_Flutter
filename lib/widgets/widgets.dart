import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable
class CommonText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "EBUZZ",
      style: TextStyle(color: HexColor("#B1A7A6"), fontSize: 10),
    );
  }
}

// ignore: non_constant_identifier_names
Widget Commontitle(child) {
  return Text(
    "$child",
    style: TextStyle(
      color: black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

// ignore: must_be_immutable
class CommonButton extends StatelessWidget {
  CommonButton({this.child, this.onPressed});
  Widget child;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primary,
            textStyle: new TextStyle(color: Colors.white),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(100),
            ),
            padding: EdgeInsets.fromLTRB(90, 12, 90, 12),
          ),
          onPressed: onPressed,
          child: child,
        ),
      ],
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text("By Continuing you agree to accept our",
              style: TextStyle(
                fontSize: 10,
                color: HexColor("#B1A7A6"),
              )),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Terms &Condations',
              style: TextStyle(
                fontSize: 12,
                color: primary,
              ),
              children: [
                TextSpan(
                  text: ' and ',
                  style: TextStyle(
                    fontSize: 12,
                    color: HexColor("#B1A7A6"),
                  ),
                ),
                TextSpan(
                  text: 'Privecy policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: primary,
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
