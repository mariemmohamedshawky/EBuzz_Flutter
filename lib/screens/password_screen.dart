import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/verification_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:ebuzz/screens/bottomappbar_screen.dart';
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
        Navigator.of(context).pushNamedAndRemoveUntil(
            BottomappbarScreen.routeName, (Route<dynamic> route) => false);
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong', () {});
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context).settings.arguments as String;
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
                          'Title',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(phone)
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
                  CommonButton(
                    child: Text('Login    '),
                    onPressed: () => _submitData(phone),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 10.0),
                      primary: primary,
                      textStyle: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        VerificationCodeScreen.routeName,
                        arguments: {'phone': phone, 'type': 'forget'},
                      );
                    },
                    child: const Text('Forget Password ?  '),
                  ),
                  Container(child: Footer()),
                ],
              ),
      ),
    );
  }
}
