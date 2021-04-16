import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import './home_screen.dart';
import '../providers/user.dart';
import '../components/warning_popup.dart';

class PasswordScreen extends StatefulWidget {
  static const String routeName = 'password-screen';
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordController = TextEditingController();
  bool passwordVisible = true;
  var _isLoading = false;

  Future<void> _submitData(phone) async {
    if (_passwordController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context, false, 'Password cant be empty', () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false)
          .login(phone, _passwordController.text);
      if (success) {
        Navigator.of(context).pushNamed(HomeScreen.routeName);
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
    } catch (error) {
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong', () {});
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context).settings.arguments as String;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Center(
                        child: Column(
                          children: <Widget>[
                            CommonText(),
                            SizedBox(height: 60),
                            Commontitle(
                              translator.translate(
                                'Title',
                              ),
                            ),
                            Text(phone),
                            SizedBox(height: 40),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(fontSize: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      color: primary,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    )),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: passwordVisible,
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              child: CommonButton(
                                child: Text('Login    '),
                                onPressed: () => _submitData(phone),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(child: Footer()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
