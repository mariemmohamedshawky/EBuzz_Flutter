import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ebuzz/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import './verification_code_screen.dart';
import './password_screen.dart';
import '../components/warning_popup.dart';

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
          context, false, 'Phone Number Required', () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false)
          .checkPhoneExist(_phoneController.text);
      if (success) {
        var exisit = Provider.of<User>(context, listen: false).isExisit;
        Navigator.of(context).pushNamed(
          exisit ? PasswordScreen.routeName : VerificationCodeScreen.routeName,
          arguments: _phoneController.text,
        );
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
                            SizedBox(height: 40),
                            Commontitle(
                                child: Text(
                              'Create better together',
                              style: TextStyle(
                                color: HexColor("#0B090A"),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            SizedBox(height: 20),
                            Text(
                              "join our community",
                              style: TextStyle(
                                  color: HexColor("#B1A7A6"), fontSize: 10),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary),
                                  ),
                                  hintText: "Enter Number",
                                  hintStyle: TextStyle(fontSize: 10),
                                ),
                                keyboardType: TextInputType.phone,
                                onSubmitted: (_) => _submitData(),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "We will send confirmation code",
                              style: TextStyle(
                                  color: HexColor("#B1A7A6"), fontSize: 10),
                            ),
                            SizedBox(height: 225),
                            Container(
                              child: CommonButton(
                                child: Text('Continue '),
                                onPressed: () => _submitData(),
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
