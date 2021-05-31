import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:provider/provider.dart';

import './moredata_screen.dart';
import '../providers/user.dart';
import '../components/warning_popup.dart';

class NewPasswordScreen extends StatefulWidget {
  static const String routeName = 'new-password-screen';
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool passwordVisible = true;
  bool passwordVisible2 = true;
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  var _isLoading = false;

  Future<void> _submitData(phone) async {
    if (_passwordController.text.isEmpty ||
        _passwordConfirmationController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context, false, 'Password Fileds cant be empty', () {});
      return;
    }

    if (_passwordController.text != _passwordConfirmationController.text) {
      WarningPopup.showWarningDialog(
          context, false, 'Password Fileds must be identical', () {});
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false).register(
          phone,
          _passwordController.text,
          _passwordConfirmationController.text);
      if (success) {
        WarningPopup.showWarningDialog(context, true, 'success created account',
            () => Navigator.of(context).pushNamed(MoreDataScreen.routeName));
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
    } catch (error) {
      print(error);
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
                              'Enter Passward',
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
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextField(
                                controller: _passwordConfirmationController,
                                onSubmitted: (_) => _submitData(phone),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(fontSize: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      color: primary,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible2 = !passwordVisible2;
                                        });
                                      },
                                    )),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: passwordVisible2,
                              ),
                            ),
                            SizedBox(height: 180),
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
