import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import './new_password_screen.dart';
import '../components/warning_popup.dart';

// ignore: must_be_immutable
class VerificationCodeScreen extends StatefulWidget {
  static const String routeName = 'verification-code-screen';
  String phone;
  String type;
  VerificationCodeScreen({this.phone, this.type});
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
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      widget.phone = args['phone'];
      widget.type = args['type'];
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
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
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
                      'verification-tittle',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    translator.translate(
                      'verification-text',
                    ),
                    style: TextStyle(color: grey, fontSize: 10),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(50),
                child: TextField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                    hintText: translator.translate(
                      'verification-hint',
                    ),
                    hintStyle: TextStyle(fontSize: 10),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                child: CommonButton(
                  child: Text(
                    translator.translate(
                      'verification-cont',
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode,
                              smsCode: _verificationCodeController.text))
                          .then((value) async {
                        if (value.user != null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              NewPasswordScreen.routeName,
                              (Route<dynamic> route) => false,
                              arguments: {
                                'phone': widget.phone,
                                'type': widget.type
                              });
                        }
                      });
                    } catch (e) {
                      WarningPopup.showWarningDialog(
                          context,
                          false,
                          translator.translate(
                            'verification-wrong-code',
                          ),
                          () {});
                    }
                  },
                ),
              ),
              Container(child: Footer()),
            ],
          ),
        ),
      ),
    );
  }
}
