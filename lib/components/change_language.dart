import 'package:ebuzz/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class ChangeLanguage extends StatelessWidget {
  static final routeName = '/change-language';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final user = Provider.of<User>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.05,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xffD6D6D6),
                  ),
                ),
              ),
              child: ListTile(
                leading: translator.currentLanguage == 'ar'
                    ? Icon(Icons.done)
                    : null,
                title: Text("عربي"),
                onTap: () {
                  translator.setNewLanguage(
                    context,
                    newLanguage: 'ar',
                    remember: true,
                    restart: false,
                  );

                  user.setLocal('ar').then((v) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SplashScreen.routeName,
                        (Route<dynamic> route) => false);
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.05,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xffD6D6D6),
                  ),
                ),
              ),
              child: ListTile(
                leading: translator.currentLanguage == 'en'
                    ? Icon(Icons.done)
                    : null,
                title: Text("English"),
                onTap: () {
                  translator.setNewLanguage(
                    context,
                    newLanguage: 'en',
                    remember: true,
                    restart: false,
                  );

                  user.setLocal('en').then((v) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SplashScreen.routeName,
                        (Route<dynamic> route) => false);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
