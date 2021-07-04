import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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

  Future<void> _forgetPassword(phone) async {
    if (_passwordController.text.isEmpty ||
        _passwordConfirmationController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'new-password-empty-field',
          ),
          () {});
      return;
    }

    if (_passwordController.text != _passwordConfirmationController.text) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'new-password-identical-field',
          ),
          () {});
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false)
          .forgetPassword(phone, _passwordController.text,
              _passwordConfirmationController.text);
      if (success) {
        WarningPopup.showWarningDialog(
            context,
            true,
            translator.translate(
              'new-password-success-created',
            ),
            () => Navigator.of(context)
                .pushNamed(PasswordScreen.routeName, arguments: phone));
      } else {
        setState(() {
          _isLoading = false;
        });
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
      return;
    }
  }

  Future<void> _submitData(phone) async {
    if (_passwordController.text.isEmpty ||
        _passwordConfirmationController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'new-password-empty-field',
          ),
          () {});
      return;
    }

    if (_passwordController.text != _passwordConfirmationController.text) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'new-password-identical-field',
          ),
          () {});
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
        WarningPopup.showWarningDialog(
            context,
            true,
            translator.translate(
              'new-password-success-created',
            ),
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                MoreDataScreen.routeName, (Route<dynamic> route) => false));
      } else {
        setState(() {
          _isLoading = false;
        });
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    print(args['type']);
    return Scaffold(
      body: Container(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CommonText(),
                      ),
                      Commontitle(
                        translator.translate(
                          'new-password-tittle',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(args['phone']),
                    ],
                  ),
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
                          hintText: translator.translate(
                            'password-page-hint',
                          ),
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
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      controller: _passwordConfirmationController,
                      onSubmitted: (_) {
                        if (args['type'] == 'forget') {
                          _forgetPassword(args['phone']);
                        } else {
                          _submitData(args['phone']);
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primary),
                          ),
                          hintText: translator.translate(
                            'new-password-confirm-hint',
                          ),
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
                  Container(
                    child: CommonButton(
                      child: Text(
                        args['type'] == 'forget'
                            ? translator.translate(
                                'password-page-change-password',
                              )
                            : translator.translate(
                                'password-page-login',
                              ),
                      ),
                      onPressed: () {
                        if (args['type'] == 'forget') {
                          _forgetPassword(args['phone']);
                        } else {
                          _submitData(args['phone']);
                        }
                      },
                    ),
                  ),
                  Container(child: Footer()),
                ],
              ),
      ),
    );
  }
}
