import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../models/emergency_model.dart';

class Emergency with ChangeNotifier {
  String errorMessage = '';
  List<EmergencyModel> _history = [];
  List<EmergencyModel> _activity = [];

  List<EmergencyModel> get historyItems {
    return [..._history];
  }

  List<EmergencyModel> get activityItems {
    return [..._activity];
  }

// --------------------------------- View Emergencies History ---------------------------------
  Future viewHistory(int page) async {
    Uri apiLink =
        Uri.https(url, '/api/v1/user/emergencies/history', {'page': '$page'});
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
                id: element['id'],
                userName: element['user_name'],
                phone: element['phone'],
                date: element['date'],
                photo: element['photo'],
                latitude: double.tryParse('${element['latitude']}'),
                longitude: double.tryParse('${element['longitude']}'),
                country: element['country'],
                countryCode: element['country_code'],
                city: element['city'],
                state: element['state'],
                road: element['road'],
                notificationCount: '${element['notification_count']}',
                massageCount: '${element['massage_count']}',
              ),
            );
          });
          _history = loadedEmergency;
          notifyListeners();
          return responseData['pagination']['meta']['total_pages'];
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
// --------------------------------------------------------------------------------------------

// --------------------------------- View Emergencies History ---------------------------------
  Future viewActivities(int page) async {
    Uri apiLink =
        Uri.https(url, '/api/v1/user/emergencies/activity', {'page': '$page'});
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
                id: element['id'],
                userName: element['user_name'],
                phone: element['phone'],
                date: element['date'],
                photo: element['photo'],
                latitude: double.tryParse('${element['latitude']}'),
                longitude: double.tryParse('${element['longitude']}'),
                country: element['country'],
                countryCode: element['country_code'],
                city: element['city'],
                state: element['state'],
                road: element['road'],
                notificationCount: '${element['notification_count']}',
                massageCount: '${element['massage_count']}',
              ),
            );
          });
          _activity = loadedEmergency;
          notifyListeners();
          return responseData['pagination']['meta']['total_pages'];
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
// --------------------------------------------------------------------------------------------

// --------------------------------- View Emergencies History ---------------------------------
  Future startEmergency() async {
    Uri apiLink = Uri.https(url, '/api/v1/user/emergencies/start');
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
// --------------------------------------------------------------------------------------------
}
