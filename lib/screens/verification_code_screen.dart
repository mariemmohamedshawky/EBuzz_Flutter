import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './new_password_screen.dart';
import '../components/warning_popup.dart';

// ignore: must_be_immutable
class VerificationCodeScreen extends StatefulWidget {
  static const String routeName = 'verification-code-screen';
  String phone;
  VerificationCodeScreen({this.phone});
  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  String _verificationCode;
  final _verificationCodeController = TextEditingController();
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget.phone = ModalRoute.of(context).settings.arguments as String;
      _verifyPhone();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+2${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.of(context).pushNamed(
                NewPasswordScreen.routeName,
                arguments: widget.phone,
              );
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Center(
                  child: Column(
                    children: <Widget>[
                      CommonText(),
                      SizedBox(height: 40),
                      Commontitle(
                        'Enter Code',
                      ),
                      SizedBox(height: 20),
                      Text(
                        "We Send it to the number",
                        style: TextStyle(color: grey, fontSize: 10),
                      ),
                      Container(
                        margin: EdgeInsets.all(70),
                        child: TextField(
                          controller: _verificationCodeController,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primary),
                            ),
                            hintText: "Code",
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 160),
                      Container(
                        child: CommonButton(
                          child: Text('Continue'),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: _verificationCode,
                                          smsCode:
                                              _verificationCodeController.text))
                                  .then((value) async {
                                if (value.user != null) {
                                  Navigator.of(context).pushNamed(
                                    NewPasswordScreen.routeName,
                                    arguments: widget.phone,
                                  );
                                }
                              });
                            } catch (e) {
                              WarningPopup.showWarningDialog(
                                  context, false, 'Code Not Correct', () {});
                            }
                          },
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