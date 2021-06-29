import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constant.dart';
import '../models/user_model.dart';

class User with ChangeNotifier {
  String _token, errorMessage = '';
  DateTime _expiryDate;
  int _userId;
  Timer _authTimer;
  bool _isExisit;
  UserModel userData = UserModel();
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
    Uri apiLink = Uri.https(url, '/api/v1/user/check-phone-exist');
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

  // --------------------------------- Update current location ---------------------------------
  Future updateLocation(double latitude, double longitude) async {
    //get location from lat and long
    var accessToken = 'pk.dde569fb191eb2551d4f78ff122ffc0d';
    String country, countryCode, state, city, road;
    Uri getLocationByLatLongLink = Uri.https(
      'us1.locationiq.com',
      '/v1/reverse.php',
      {
        'lat': '$latitude',
        'lon': '$longitude',
        'key': '$accessToken',
        'format': 'json',
      },
    );
    print(getLocationByLatLongLink);
    try {
      var locationResponse = await http.get(getLocationByLatLongLink);
      final Map<String, dynamic> locationData =
          json.decode(locationResponse.body);
      road = locationData['address']['road'] ?? '';
      country = locationData['address']['country'] ?? '';
      countryCode = locationData['address']['country_code'] ?? '';
      state = locationData['address']['state'] ?? '';
      city = locationData['address']['city'] ?? '';
    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return false;
    }
    //---------------------------------------------------------------

    // update user location
    Uri apiLink = Uri.https(url, '/api/v1/user/location/update');
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.post(
        apiLink,
        body: json.encode(
          {
            'latitude': latitude,
            'longitude': longitude,
            'country': country,
            'country_code': countryCode,
            'state': state,
            'city': city,
            'road': road,
          },
        ),
        headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        },
      );
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);

      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          return true;
        } else if (responseData['errNum'] == "401") {
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
    Uri apiLink = Uri.https(url, '/api/v1/user/$type');
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
              seconds: (60 * 60 * 24 * 7),
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
          getUserDate(); // get the user data and asign it into the model
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

  // --------------------------------- Get User Data ---------------------------------
  Future getUserDate() async {
    Uri apiLink = Uri.https(url, '/api/v1/user/profile');
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.get(
        apiLink,
        headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        },
      );
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);

      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          userData = UserModel(
            id: responseData['data']['id'],
            phone: responseData['data']['phone'],
            address: responseData['data']['address'],
            gender: responseData['data']['gender'],
            age: responseData['data']['age'] != null
                ? int.parse(responseData['data']['age'])
                : 0,
            smsAlert: responseData['data']['sms_alert'],
            firstName: responseData['data']['first_name'],
            lastName: responseData['data']['last_name'],
            photo: responseData['data']['photo'],
            latitude: double.tryParse('${responseData['data']['latitude']}'),
            longitude: double.tryParse('${responseData['data']['longitude']}'),
          );
          if (responseData['data']['block'] == "1") {
            logout();
          }
          return true;
        } else if (responseData['errNum'] == "401") {
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

  // ----------------------------- Update Profile -----------------------------

  Future updateProfile(
    File image,
    String firstName,
    String lastName,
    String address,
    int age,
    String gender,
  ) async {
    try {
      final imageUploadRequest = http.MultipartRequest(
          'POST', Uri.https(url, "/api/v1/user/profile/update"));
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
      print(imageUploadRequest); // during development cycle
      imageUploadRequest.fields['first_name'] = firstName;
      imageUploadRequest.fields['last_name'] = lastName;
      imageUploadRequest.fields['address'] = address;
      imageUploadRequest.fields['gender'] = gender == null ? '' : gender;
      imageUploadRequest.fields['age'] = '$age';
      print(
          "here ${json.encode(imageUploadRequest.fields)}"); // during development cycle
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);

      //------------- start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          getUserDate();
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
          if (responseData['msg'].containsKey('age')) {
            errorMessage += "${responseData['msg']['age'][0]}\n";
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

  // ---------------- update smsAlert ------------------------------------
  Future changeMassage(String smsAlert) async {
    Uri apiLink = Uri.https(url, '/api/v1/user/profile/update_sms_alert');
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.post(
        apiLink,
        body: json.encode(
          {
            'sms_alert': smsAlert,
          },
        ),
        headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        },
      );
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);

      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['errNum'] == "200") {
          userData.smsAlert = smsAlert;
          notifyListeners();
          return true;
        } else if (responseData['errNum'] == "401") {
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

// ----------------------------- Logout -----------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    await updateFCMToken('null');
    notifyListeners();
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
    getUserDate(); // get the user data and asign it into the model
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

  Future<void> updateFCMToken(fcmToken) async {
    try {
      final response = await http.post(
        Uri.https(url, '/api/v1/user/fcm-token'),
        body: {"fcm_token": fcmToken},
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
