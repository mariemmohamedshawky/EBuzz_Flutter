import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../models/post_model.dart';

class Post with ChangeNotifier {
  String errorMessage = '';
  List<PostModel> _items = [];
  List<PostModel> _myPosts = [];

  List<PostModel> get items {
    return [..._items];
  }

  List<PostModel> get myPosts {
    return [..._myPosts];
  }

// --------------------------------- View Posts ---------------------------------
  Future viewPosts(int page) async {
    Uri apiLink = Uri.https(url, '/api/v1/user/posts', {'page': '$page'});
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
          final List<PostModel> loadedPosts = [];
          var data = responseData['data'] as List<dynamic>;
          data.forEach((element) {
            loadedPosts.add(
              PostModel(
                id: element['id'],
                userName: element['user_name'],
                date: element['date'],
                city: element['city'],
                cityId: element['city_id'],
                status: element['status'],
                description: element['description'],
                postPhoto: element['photo'],
                userPhoto: element['user_photo'],
              ),
            );
          });
          _items = loadedPosts;
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

// --------------------------------- My Posts ---------------------------------
  Future viewMyPosts(int page) async {
    Uri apiLink =
        Uri.https(url, '/api/v1/user/posts/my_posts', {'page': '$page'});
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
          final List<PostModel> loadedPosts = [];
          var data = responseData['data'] as List<dynamic>;
          data.forEach((element) {
            loadedPosts.add(
              PostModel(
                id: element['id'],
                userName: element['user_name'],
                date: element['date'],
                city: element['city'],
                cityId: element['city_id'],
                status: element['status'],
                description: element['description'],
                postPhoto: element['photo'],
                userPhoto: element['user_photo'],
              ),
            );
          });
          _myPosts = loadedPosts;
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

// --------------------------------- Add Post ---------------------------------
  Future addPost(
    File image,
    String description,
    int city,
  ) async {
    try {
      //get use token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = extractedUserData['token'];
      //------------------------------------

      final imageUploadRequest = http.MultipartRequest(
          'POST', Uri.https(url, "/api/v1/user/posts/create"));
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
      imageUploadRequest.fields['description'] = description;
      imageUploadRequest.fields['city_id'] = '$city';
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
          if (responseData['msg'].containsKey('city_id')) {
            errorMessage += "${responseData['msg']['city_id'][0]}\n";
          }
          if (responseData['msg'].containsKey('description')) {
            errorMessage += "${responseData['msg']['description'][0]}\n";
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

// --------------------------------- update Post ---------------------------------
  Future updatePost(
      File image, String description, int city, int postId) async {
    try {
      //get use token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = extractedUserData['token'];
      //------------------------------------

      final imageUploadRequest = http.MultipartRequest(
          'POST', Uri.https(url, "/api/v1/user/posts/update"));
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
      imageUploadRequest.fields['description'] = description;
      imageUploadRequest.fields['city_id'] = '$city';
      imageUploadRequest.fields['post_id'] = '$postId';
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
          if (responseData['msg'].containsKey('city_id')) {
            errorMessage += "${responseData['msg']['city_id'][0]}\n";
          }
          if (responseData['msg'].containsKey('description')) {
            errorMessage += "${responseData['msg']['description'][0]}\n";
          }
          if (responseData['msg'].containsKey('photo')) {
            errorMessage += "${responseData['msg']['photo'][0]}\n";
          }
          if (responseData['msg'].containsKey('post_id')) {
            errorMessage += "${responseData['msg']['post_id'][0]}\n";
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

  // --------------------------------- delete Post ---------------------------------
  Future deletePost(int id) async {
    Uri apiLink = Uri.https(url, '/api/v1/user/posts/delete/$id');
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
          final existingPostndex =
              _myPosts.indexWhere((contact) => contact.id == id);
          _myPosts.removeAt(existingPostndex);
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
