// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:ebuzz/components/change_language.dart';
import 'package:ebuzz/components/pickers/profile_image_picker.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/providers/user.dart';
import 'package:ebuzz/screens/bottomappbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import '../components/warning_popup.dart';

enum Gender { male, female }

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile-screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

enum genderEnum { male, female }

class _ProfileScreenState extends State<ProfileScreen> {
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
  var _isInit = true;
  var user;

  changeGender(value) {
    setState(() {
      _gender = value;
    });
  }

  void _pickedImage(File image) {
    _image = image;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      user = Provider.of<User>(context);
      _gender = user.userData.gender;
      _userFirstname = user.userData.firstName;
      _userLastname = user.userData.lastName;
      _userAddress = user.userData.address;
      _userAge = user.userData.age;
    }
    _isInit = false;
    super.didChangeDependencies();
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
        WarningPopup.showWarningDialog(
            context,
            true,
            translator.translate(
              'profile-page-update-success',
            ), () {
          Navigator.of(context).pushNamed(BottomappbarScreen.routeName);
        });
      } else {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<User>(context, listen: false).errorMessage, () {});
      }
    } catch (error) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            translator.translate(
              'profile-page-tittle',
            ),
            style: TextStyle(
                color: black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Center(
                        child: Form(
                          key: _form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Center(
                                child: ProfileImagePicker(_pickedImage),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 1, 20, 1),
                                          child: Text(
                                            translator.translate(
                                              'profile-page-first-name',
                                            ),
                                            style: TextStyle(
                                                color: grey, fontSize: 10),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          margin:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: TextFormField(
                                            initialValue: _userFirstname,
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _lastNameFocusNode);
                                            },
                                            onSaved: (value) {
                                              setState(() {
                                                _userFirstname = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: primary),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: primary),
                                              ),
                                            ),
                                            keyboardType: TextInputType.name,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 1, 20, 1),
                                          child: Text(
                                            translator.translate(
                                              'profile-page-last-name',
                                            ),
                                            style: TextStyle(
                                                color: grey, fontSize: 10),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          margin:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: TextFormField(
                                            initialValue: _userLastname,
                                            focusNode: _lastNameFocusNode,
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _addressFocusNode);
                                            },
                                            onSaved: (value) {
                                              setState(() {
                                                _userLastname = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: primary),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: primary),
                                              ),
                                            ),
                                            keyboardType: TextInputType.name,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                child: Text(
                                  translator.translate(
                                    'profile-page-address',
                                  ),
                                  style: TextStyle(color: grey, fontSize: 10),
                                ),
                              ),
                              Container(
                                height: 30,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  initialValue: _userAddress,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_ageFocusNode);
                                  },
                                  focusNode: _addressFocusNode,
                                  onSaved: (value) {
                                    setState(() {
                                      _userAddress = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                child: Text(
                                  translator.translate(
                                    'profile-page-age',
                                  ),
                                  style: TextStyle(color: grey, fontSize: 10),
                                ),
                              ),
                              Container(
                                height: 30,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  initialValue: '$_userAge',
                                  focusNode: _ageFocusNode,
                                  onSaved: (value) {
                                    setState(() {
                                      _userAge = int.parse(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                ),
                              ),
                              SizedBox(height: 30),
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
                                          translator.translate(
                                            'profile-page-male',
                                          ),
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
                                          translator.translate(
                                            'profile-page-female',
                                          ),
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      FloatingActionButton.extended(
                        backgroundColor: primary,
                        onPressed: () => _saveForm(),
                        label: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            translator.translate(
                              'profile-page-update',
                            ),
                            style: TextStyle(
                              fontSize: 20,
                            ),
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
