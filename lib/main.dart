import 'package:ebuzz/providers/contact.dart';
import 'package:ebuzz/screens/notification_screen.dart';
import 'package:ebuzz/screens/selected_contacts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import './providers/user.dart';
import './providers/contact.dart';
import './providers/emergency.dart';
import './providers/notification.dart' as notificationProvider;
import './screens/activity_screen.dart';
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
import './screens/verification_code_screen.dart';
import './screens/notification_screen.dart';
import './screens/call_screen.dart';
import './components/change_language.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
    apiKeyGoogle: '<Key>', // NOT YET TESTED
  );
  // intialize

  runApp(LocalizedApp(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Contact(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Emergency(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => notificationProvider.Notification(),
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
            localizationsDelegates: translator.delegates,
            locale: translator.locale,
            supportedLocales: translator.locals(),
            routes: <String, WidgetBuilder>{
              NewPasswordScreen.routeName: (ctx) => NewPasswordScreen(),
              PasswordScreen.routeName: (ctx) => PasswordScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(user: auth),
              SplashScreen.routeName: (ctx) => SplashScreen(),
              OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
              EnterPhoneScreen.routeName: (ctx) => EnterPhoneScreen(),
              MassageScreen.routeName: (ctx) => MassageScreen(),
              MoreDataScreen.routeName: (ctx) => MoreDataScreen(),
              HistoryScreen.routeName: (ctx) => HistoryScreen(),
              CongratsScreen.routeName: (ctx) => CongratsScreen(),
              ActivityScreen.routeName: (ctx) => ActivityScreen(),
              VerificationCodeScreen.routeName: (ctx) =>
                  VerificationCodeScreen(),
              ChangeLanguage.routeName: (ctx) => ChangeLanguage(),
              NotificationScreen.routeName: (ctx) => NotificationScreen(),
              CallScreen.routeName: (ctx) => CallScreen(),
              SelectedContactsScreen.routeName: (ctx) =>
                  SelectedContactsScreen(),
            }),
      ),
    );
  }
}
