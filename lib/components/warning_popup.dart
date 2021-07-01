import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WarningPopup {
  static showWarningDialog(
      BuildContext context, bool sussess, String errorMessage, Function then) {
    final mediaQuery = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: sussess ? Colors.green : Colors.red,
          content: Container(
            width: mediaQuery.size.width * 0.7,
            height: mediaQuery.size.height * 0.45,
            child: Column(
              children: <Widget>[
                Container(
                  width: mediaQuery.size.height * 0.12,
                  height: mediaQuery.size.height * 0.12,
                  margin: EdgeInsets.only(
                      top: mediaQuery.size.height * 0.03,
                      bottom: mediaQuery.size.height * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Icon(
                    sussess ? Icons.done : Icons.clear,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                Text(
                  sussess
                      ? translator.translate(
                          'component-warning-success',
                        )
                      : translator.translate(
                          'component-warning-error',
                        ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.05,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Text(
                        errorMessage,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.01,
                ),
                Container(
                  width: mediaQuery.size.width * 0.5,
                  height: mediaQuery.size.height * 0.06,
                  margin: EdgeInsets.only(
                    top: mediaQuery.size.height * 0.01,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      if (sussess) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      sussess
                          ? translator.translate(
                              'component-warning-cont',
                            )
                          : translator.translate('component-warning-try-again'),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((_) {
      then();
    });
  }
}
