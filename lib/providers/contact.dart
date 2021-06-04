import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constant.dart';
import '../models/contact_model.dart';

class Contact with ChangeNotifier {
  String errorMessage = '';
  List<ContactModel> _items = [];

  List<ContactModel> get items {
    return [..._items];
  }

  // --------------------------------- View Contacts ---------------------------------
  Future viewContacts() async {
    Uri apiLink = Uri.https(url, '/api/v1/user/contact/view');
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
          final List<ContactModel> loadedContacts = [];
          var data = responseData['data'] as List<dynamic>;
          data.forEach((element) {
            loadedContacts.add(
              ContactModel(
                fullName: element['full_name'],
                phone: element['phone'],
                id: element['id'],
              ),
            );
          });
          _items = loadedContacts;
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

  // --------------------------------- delete Contact ---------------------------------
  Future deleteContact(int id) async {
    Uri apiLink = Uri.https(url, '/api/v1/user/contact/delete/$id');
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
          final existingContactndex =
              _items.indexWhere((contact) => contact.id == id);
          _items.removeAt(existingContactndex);
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

  // --------------------------------- Add Contacts ---------------------------------
  Future addContacts(List<Map<String, String>> contacts) async {
    Uri apiLink = Uri.https(url, '/api/v1/user/contact/add');
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      //get use token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = extractedUserData['token'];
      //------------------------------------

      final response = await http.post(
        apiLink,
        body: json.encode(
          {
            'contacts': contacts,
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

}
