// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:ebuzz/components/pickers/dateofbirth_picker.dart';
import 'package:ebuzz/components/pickers/profile_image_picker.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/providers/user.dart';
import 'package:flutter/material.dart';
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
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  String _userFirstname, _userLastname, _userAddress, _gender;
  DateTime _selectedDate;
  File _image;
  var _isLoading = false;
  var user;
  var _isInit = true;

  changeGender(value) {
    setState(() {
      _gender = value;
    });
  }

  void _pickedImage(File image) {
    _image = image;
  }

  void _pickedDate(DateTime date) {
    _selectedDate = date;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      user = Provider.of<User>(context);
      _gender = user.userData.gender;
      _userFirstname = user.userData.firstName;
      _userLastname = user.userData.lastName;
      _userAddress = user.userData.address;
      _selectedDate = DateTime.parse(user.userData.dateOfBirth);
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
        _selectedDate,
        _gender,
      );
      if (success) {
        WarningPopup.showWarningDialog(
            context, true, 'Profile Updated Successfully', () {});
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Profile',
            style: TextStyle(
                color: black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => _saveForm(),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green[300],
                size: 30,
              ),
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                child: Text(
                                  'First Name',
                                  style: TextStyle(color: grey, fontSize: 10),
                                ),
                              ),
                              Container(
                                height: 40,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  initialValue: _userFirstname,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lastNameFocusNode);
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      _userFirstname = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                child: Text(
                                  'Last Name',
                                  style: TextStyle(color: grey, fontSize: 10),
                                ),
                              ),
                              Container(
                                height: 40,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  initialValue: _userLastname,
                                  focusNode: _lastNameFocusNode,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_addressFocusNode);
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      _userLastname = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                child: Text(
                                  'Address',
                                  style: TextStyle(color: grey, fontSize: 10),
                                ),
                              ),
                              Container(
                                height: 40,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  initialValue: _userAddress,
                                  focusNode: _addressFocusNode,
                                  onSaved: (value) {
                                    setState(() {
                                      _userAddress = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primary),
                                    ),
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: DateOfBirthPicker(_pickedDate),
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
