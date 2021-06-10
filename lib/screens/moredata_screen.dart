import 'dart:io';

import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/widgets/widgets.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ebuzz/screens/bottomappbar_screen.dart';
import '../providers/user.dart';
import '../components/pickers/profile_image_picker.dart';
import '../components/warning_popup.dart';
import './congrats_screen.dart';

class MoreDataScreen extends StatefulWidget {
  static const String routeName = 'moredata-screen';
  @override
  _MoreDataScreenState createState() => _MoreDataScreenState();
}

class _MoreDataScreenState extends State<MoreDataScreen> {
  final _form = GlobalKey<FormState>();
  final _lastNameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  String _userFirstname, _userLastname, _userAddress, _gender;
  int _userAge;
  File _image;
  var _isLoading = false;

  changeGender(value) {
    setState(() {
      _gender = value;
    });
  }

  void _pickedImage(File image) {
    _image = image;
  }

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      var success =
          await Provider.of<User>(context, listen: false).updateProfile(
        _image,
        _userFirstname,
        _userLastname,
        _userAddress,
        _userAge,
        _gender,
      );
      if (success) {
        Navigator.of(context).pushNamed(BottomappbarScreen.routeName);
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
        setState(() {
          _isLoading = false;
        });
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
    final mediaQuery = MediaQuery.of(context);
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
                        child: Form(
                          key: _form,
                          child: Column(
                            children: <Widget>[
                              CommonText(),
                              SizedBox(height: 40),
                              Commontitle(
                                'More Data',
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ProfileImagePicker(_pickedImage),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lastNameFocusNode);
                                  },
                                  onSaved: (value) {
                                    _userFirstname = value;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    hintText: "First Name",
                                    hintStyle: TextStyle(fontSize: 10),
                                  ),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  focusNode: _lastNameFocusNode,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_addressFocusNode);
                                  },
                                  onSaved: (value) {
                                    _userLastname = value;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(fontSize: 10),
                                  ),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  focusNode: _addressFocusNode,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_ageFocusNode);
                                  },
                                  onSaved: (value) {
                                    _userAddress = value;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    hintText: "Address",
                                    hintStyle: TextStyle(fontSize: 10),
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  focusNode: _ageFocusNode,
                                  onSaved: (value) {
                                    _userAge = int.parse(value);
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    hintText: "Age",
                                    hintStyle: TextStyle(fontSize: 10),
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.only(
                                    left: mediaQuery.size.width * 0.01,
                                    right: mediaQuery.size.width * 0.01,
                                    bottom: (mediaQuery.size.height -
                                            mediaQuery.padding.top) *
                                        0.01),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: RadioListTile(
                                        activeColor: primary,
                                        title: Text(
                                          "Male",
                                          style: const TextStyle(
                                            color: Color(0xff1c305b),
                                          ),
                                        ),
                                        value: 'male',
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          changeGender(value);
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: RadioListTile(
                                        activeColor: primary,
                                        title: Text(
                                          "Female",
                                          style: const TextStyle(
                                            color: Color(0xff1c305b),
                                          ),
                                        ),
                                        value: 'female',
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          changeGender(value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: secondary,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomappbarScreen()),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: CommonButton(
                                  child: Text('Continue'),
                                  onPressed: () => _saveForm(),
                                ),
                              ),
                              SizedBox(height: 25),
                              Container(child: Footer()),
                            ],
                          ),
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
