import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constant.dart';

class User with ChangeNotifier {
  String _token, errorMessage = '';
  DateTime _expiryDate;
  int _userId;
  Timer _authTimer;
  bool _isExisit;
  String locale = 'en';

  bool get isAuth {
    return token != null;
  }

  bool get isExisit {
    return _isExisit;
  }

  int get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future setLocal(String locale) async {
    this.locale = locale;
    notifyListeners();
  }

  // --------------------------------- Check phone exist ---------------------------------
  Future checkPhoneExist(String phone) async {
    final apiLink = '$url/v1/user/check-phone-exist';
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.post(
        apiLink,
        body: json.encode(
          {
            'phone': phone,
          },
        ),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);

      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          _isExisit = responseData['msg'];
          return true;
        } else if (responseData['errNum'] == "401") {
          if (responseData['msg'].containsKey('phone')) {
            errorMessage += "${responseData['msg']['phone'][0]}\n";
          }
          return false;
        } else {
          errorMessage = "SomeThing Went Wrong!\n";
          return false;
        }
      } else {
        errorMessage = "SomeThing Went Wrong!!\n";
        return false;
      }
      //-------------end error handling -------------

    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return false;
    }
  }
  // ------------------------------------------------------------------

  // ----------------------------- Login && Register-----------------------------

  Future register(
      String phone, String password, String passwordConfirmation) async {
    return _authenticate(phone, password, passwordConfirmation, 'register');
  }

  Future login(String phone, String password) async {
    return _authenticate(phone, password, null, 'login');
  }

  Future _authenticate(String phone, String password,
      String passwordConfirmation, String type) async {
    final apiLink = '$url/v1/user/$type';
    errorMessage = '';
    Map<String, dynamic> authData;
    if (type == 'register') {
      authData = {
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
    } else {
      authData = {
        'phone': phone,
        'password': password,
      };
    }
    print(apiLink);
    try {
      final response = await http.post(
        apiLink,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);

      //------------- start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          _token = responseData['data']['user_token'];
          _userId = responseData['data']['user_id'];
          _expiryDate = DateTime.now().add(
            Duration(
              seconds: (60 * 24 * 7),
            ),
          );
          _autoLogout();
          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'token': _token,
              'userId': _userId,
              'expiryDate': _expiryDate.toIso8601String()
            },
          );
          prefs.setString('userData', userData);
          return true;
        } else if (responseData['errNum'] == "401") {
          if (responseData['msg'].containsKey('phone')) {
            errorMessage += "${responseData['msg']['phone'][0]}\n";
          }
          if (responseData['msg'].containsKey('password')) {
            errorMessage += "${responseData['msg']['password'][0]}\n";
          }

          return false;
        } else if (responseData['errNum'] == "500") {
          errorMessage += "${responseData['msg']}\n";
          return false;
        } else {
          errorMessage = "SomeThing Went Wrong!\n";
          return false;
        }
      } else {
        errorMessage = "SomeThing Went Wrong!!\n";
        return false;
      }
      //------------- end error handling -------------

    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return false;
    }
  }
  // ------------------------------------------------------------------

  // ----------------------------- Update Profile -----------------------------

  Future updateProfile(
    File image,
    String firstName,
    String lastName,
    String address,
    DateTime dateOfBirth,
    String gender,
  ) async {
    try {
      final imageUploadRequest = http.MultipartRequest(
          'POST', Uri.parse("$url/v1/user/profile/update"));
      errorMessage = '';
      if (image != null) {
        imageUploadRequest.files.add(await http.MultipartFile.fromPath(
          'photo',
          image.path,
          contentType: MediaType('application', 'x-tar'),
        ));
      }
      imageUploadRequest.headers['Authorization'] = "Bearer $token";
      imageUploadRequest.headers['Content-Type'] = "application/json";
      final dateformat = new DateFormat('yyyy-MM-dd');
      String dateOfBirthFormated =
          dateOfBirth == null ? '' : dateformat.format(dateOfBirth);
      print(imageUploadRequest); // during development cycle
      imageUploadRequest.fields['first_name'] = firstName;
      imageUploadRequest.fields['last_name'] = lastName;
      imageUploadRequest.fields['address'] = address;
      imageUploadRequest.fields['gender'] = gender == null ? '' : gender;
      imageUploadRequest.fields['date_of_birth'] = dateOfBirthFormated;
      print(
          "here ${json.encode(imageUploadRequest.fields)}"); // during development cycle
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);

      //------------- start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          notifyListeners();
          return true;
        } else if (responseData['errNum'] == "401") {
          if (responseData['msg'].containsKey('first_name')) {
            errorMessage += "${responseData['msg']['first_name'][0]}\n";
          }
          if (responseData['msg'].containsKey('last_name')) {
            errorMessage += "${responseData['msg']['last_name'][0]}\n";
          }
          if (responseData['msg'].containsKey('address')) {
            errorMessage += "${responseData['msg']['address'][0]}\n";
          }
          if (responseData['msg'].containsKey('gender')) {
            errorMessage += "${responseData['msg']['gender'][0]}\n";
          }
          if (responseData['msg'].containsKey('date_of_birth')) {
            errorMessage += "${responseData['msg']['date_of_birth'][0]}\n";
          }
          if (responseData['msg'].containsKey('photo')) {
            errorMessage += "${responseData['msg']['photo'][0]}\n";
          }
          return false;
        } else {
          errorMessage = "SomeThing Went Wrong!\n";
          return false;
        }
      } else {
        errorMessage = "SomeThing Went Wrong!!\n";
        return false;
      }
      //------------- end error handling -------------

    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return false;
    }
  }

  // ------------------------------------------------------------------

// ----------------------------- Logout -----------------------------
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
  // ------------------------------------------------------------------

  // ----------------------------- Auto Functions -----------------------------
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  // ------------------------------------------------------------------

}
