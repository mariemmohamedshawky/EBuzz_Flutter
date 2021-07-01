import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../models/city_model.dart';

class City with ChangeNotifier {
  String errorMessage = '';
  List<CityModel> _items = [];

  List<CityModel> get items {
    return [..._items];
  }

// --------------------------------- View Notifications ---------------------------------
  Future viewCities() async {
    Uri apiLink = Uri.https(url, '/api/v1/user/cities/view');
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
          final List<CityModel> loadedCities = [];
          var data = responseData['data'] as List<dynamic>;
          data.forEach((element) {
            loadedCities.add(
              CityModel(
                id: element['id'],
                name: element['name'],
              ),
            );
          });
          _items = loadedCities;
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
