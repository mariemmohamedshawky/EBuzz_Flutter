import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../models/emergency_model.dart';

class Emergency with ChangeNotifier {
  String errorMessage = '';
  List<EmergencyModel> _items = [];

  List<EmergencyModel> get items {
    return [..._items];
  }

// --------------------------------- View Contacts ---------------------------------
  Future viewHistory() async {
    Uri apiLink = Uri.https(url, '/api/v1/user/notifications');
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
          final List<EmergencyModel> loadedEmergency = [];
          var data = responseData['data'] as List<dynamic>;
          data.forEach((element) {
            loadedEmergency.add(
              EmergencyModel(
                id: element['emergency']['id'],
                userName: element['emergency']['user_name'],
                date: element['emergency']['date'],
                photo: element['emergency']['photo'],
                latitude:
                    double.tryParse('${element['emergency']['latitude']}'),
                longitude:
                    double.tryParse('${element['emergency']['longitude']}'),
                country: element['emergency']['country'],
                countryCode: element['emergency']['country_code'],
                city: element['emergency']['city'],
                state: element['emergency']['state'],
                road: element['emergency']['road'],
                notificationCount:
                    '${element['emergency']['notification_count']}',
                massageCount: '${element['emergency']['massage_count']}',
              ),
            );
          });
          _items = loadedEmergency;
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
