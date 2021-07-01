import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../constants/constant.dart';

class Report with ChangeNotifier {
  String errorMessage = '';

// --------------------------------- Report User ---------------------------------
  Future report(int emergencyId, String reason) async {
    Uri apiLink = Uri.https(url, '/api/v1/user/report/add');
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      //get use token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = extractedUserData['token'];
      //------------------------------------

      final response = await http.post(apiLink,
          headers: {
            'Authorization': "Bearer $token",
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'emergency_id': emergencyId,
            'reason': reason,
          }));
      print(response.body); // during development cycle
      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
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
// --------------------------------------------------------------------------------------------
}
