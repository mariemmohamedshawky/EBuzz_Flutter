import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import './verification_code_screen.dart';
import './password_screen.dart';
import '../components/warning_popup.dart';
import '../components/change_language.dart';

class EnterPhoneScreen extends StatefulWidget {
  static const String routeName = 'enter-phone-screen';
  @override
  _EnterPhoneScreenState createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  final _phoneController = TextEditingController();
  var _isLoading = false;

  Future<void> _submitData() async {
    if (_phoneController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'phone-page-phone required',
          ),
          () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false)
          .checkPhoneExist(_phoneController.text);
      setState(() {
        _isLoading = false;
      });
      if (success) {
        var exisit = Provider.of<User>(context, listen: false).isExisit;
        Navigator.of(context).pushNamed(
          exisit ? PasswordScreen.routeName : VerificationCodeScreen.routeName,
          arguments: exisit
              ? _phoneController.text
              : {'phone': _phoneController.text, 'type': 'register'},
        );
      } else {
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
    final user = Provider.of<User>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: grey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          Row(
            children: [
              Text(
                user.locale == 'ar' ? 'عربي' : 'English',
                style: TextStyle(
                  color: black,
                  fontSize: 17,
                ),
              ),
              IconButton(
                icon: Icon(Icons.language_rounded),
                color: grey,
                onPressed: () {
                  Navigator.of(context).pushNamed(ChangeLanguage.routeName);
                },
              ),
            ],
          ),
        ],
      ),
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
                      CommonText(),
                      SizedBox(
                        height: 10,
                      ),
                      Commontitle(
                        translator.translate(
                          'appTitle',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        translator.translate(
                          'phone-page-join',
                        ),
                        style: TextStyle(color: grey, fontSize: 10),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                        hintText: translator.translate(
                          'phone-page-hint',
                        ),
                        hintStyle: TextStyle(fontSize: 10),
                      ),
                      keyboardType: TextInputType.phone,
                      onSubmitted: (_) => _submitData(),
                    ),
                  ),
                  Text(
                    translator.translate(
                      'phone-page-code',
                    ),
                    style: TextStyle(color: grey, fontSize: 10),
                  ),
                  CommonButton(
                    child: Text(
                      translator.translate(
                        'phone-page-cont',
                      ),
                    ),
                    onPressed: () => _submitData(),
                  ),
                  Container(child: Footer()),
                ],
              ),
      ),
    );
  }
}
