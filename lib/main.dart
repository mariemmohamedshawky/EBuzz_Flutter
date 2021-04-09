import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/user.dart';
import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './screens/new_password_screen.dart';
import './screens/password_screen.dart';
import './screens/profile_screen.dart';
import './screens/onboarding_screen.dart';
import './screens/enter_phone_screen.dart';
import './screens/massage_screen.dart';
import './screens/moredata_screen.dart';
import './screens/history_screen.dart';
import './screens/congrats_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
      ],
      child: Consumer<User>(
        builder: (ctx, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => SplashScreen(),
                  ),
            routes: <String, WidgetBuilder>{
              NewPasswordScreen.routeName: (ctx) => NewPasswordScreen(),
              PasswordScreen.routeName: (ctx) => PasswordScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              SplashScreen.routeName: (ctx) => SplashScreen(),
              OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
              EnterPhoneScreen.routeName: (ctx) => EnterPhoneScreen(),
              MassageScreen.routeName: (ctx) => MassageScreen(),
              MoreDataScreen.routeName: (ctx) => MoreDataScreen(),
              HistoryScreen.routeName: (ctx) => HistoryScreen(),
              CongratsScreen.routeName: (ctx) => CongratsScreen(),
              //'/MoreDataPage': (BuildContext context) => new MoreDataPage(),
            }),
      ),
    );
  }
}
