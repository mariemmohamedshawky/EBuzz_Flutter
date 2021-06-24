import 'dart:convert';

import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Users with ChangeNotifier {
  String errorMessage = '';
  List<UserModel> _items = [];

  List<UserModel> get items {
    return [..._items];
  }

// --------------------------------- View Notifications ---------------------------------
  Future viewUsers() async {
    Uri apiLink = Uri.https(url, '/api/v1/user/users/all');
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      //get use token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = extractedUserData['token'];
      //------------------------------------

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
          final List<UserModel> loadedUser = [];
          var data = responseData['data'] as List<dynamic>;
          data.forEach((element) {
            loadedUser.add(
              UserModel(
                id: element['id'],
                age: element['age'] != null ? int.parse(element['age']) : 0,
                address: element['address'],
                gender: element['gender'],
                phone: element['phone'],
                smsAlert: element['sms_alert'],
                firstName: element['first_name'],
                lastName: element['last_name'],
                photo: element['photo'],
                latitude: double.tryParse('${element['latitude']}'),
                longitude: double.tryParse('${element['longitude']}'),
              ),
            );
          });
          _items = loadedUser;
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

}
