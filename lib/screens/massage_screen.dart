import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/contact.dart' as contactProvider;
import '../components/warning_popup.dart';
import '../constants/constant.dart';

class MassageScreen extends StatefulWidget {
  static const String routeName = 'masssage-screen';
  @override
  _MassageScreenState createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {
  TextEditingController _messageController = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    getAddedContacts();
    super.initState();
  }

  Future<void> getAddedContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<contactProvider.Contact>(context, listen: false)
          .viewContacts();
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, translator.translate('wrong-message'), () {});
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitData() async {
    if (_messageController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context, false, translator.translate('message-required'), () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success = await Provider.of<User>(context, listen: false)
          .changeMassage(_messageController.text);
      if (success) {
        WarningPopup.showWarningDialog(
            context, true, translator.translate('message-updated'), () => {});
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, translator.translate('wrong-message'), () {});
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: Text(
          translator.translate('massege-title'),
          style: TextStyle(
              color: black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: _isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 50),
                      Container(
                        child: Text(translator.translate('massege-header'),
                            style: TextStyle(
                              fontSize: 12,
                              color: grey,
                            )),
                      ),
                      RichText(
                        //  textAlign: TextAlign.center,
                        text: TextSpan(
                            text: translator.translate('massege-header2'),
                            style: TextStyle(
                              fontSize: 15,
                              color: primary,
                            ),
                            children: [
                              TextSpan(
                                text: translator.translate('massege-header3'),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: grey,
                                ),
                              ),
                              TextSpan(
                                text: translator.translate('massege-header4'),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: primary,
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 200,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Form(
                              child: TextField(
                                controller: _messageController
                                  ..text = user.userData.smsAlert,
                                decoration: InputDecoration.collapsed(
                                  hintText:
                                      translator.translate('massege-textfield'),
                                  hintStyle: TextStyle(
                                    color: grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton.extended(
                        backgroundColor: primary,
                        onPressed: () => _submitData(),
                        icon: Icon(Icons.save),
                        label: Text(
                          translator.translate('massege-button'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
