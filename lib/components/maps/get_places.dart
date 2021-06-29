import 'dart:convert';
import 'dart:async';

import 'package:ebuzz/components/maps/place_search.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:http/http.dart' as http;

class GetPlaces {
  String errorMessage = '';

  Future getPlaces(double latitude, double longitude, String placeType) async {
    Uri apiLink = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/textsearch/json',
      {
        'key': Map_Key,
        'rankby': 'distance',
        'location': '$latitude,$longitude',
        'type': placeType,
      },
    );
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.get(
        apiLink,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body); // during development cycle
      final Map<String, dynamic> responseData = json.decode(response.body);
      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData['results'] as List;
      } else {
        errorMessage = "SomeThing Went Wrong!!\n";
        return null;
      }
      //-------------end error handling -------------

    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return null;
    }
  }
  // ------------------------------------------------------------------

  Future getPlacesAutocomplete(String search) async {
    Uri apiLink =
        Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {
      'key': Map_Key,
      'type': '(cities)',
      'input': search,
    });
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.get(
        apiLink,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body); // during development cycle
      var responseData = json.decode(response.body);
      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResults = responseData['predictions'] as List;
        return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
      } else {
        errorMessage = "SomeThing Went Wrong!!\n";
        return null;
      }
      //-------------end error handling -------------

    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return null;
    }
  }
  // ------------------------------------------------------------------

  Future getPlaceDetails(String placeId) async {
    Uri apiLink =
        Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
      'key': Map_Key,
      'place_id': placeId,
    });
    print(apiLink); // during development cycle
    errorMessage = '';
    try {
      final response = await http.get(
        apiLink,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body); // during development cycle
      var responseData = json.decode(response.body);
      //-------------start error handling -------------
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResults = responseData['result'] as Map<String, dynamic>;
        return jsonResults['geometry']['location'];
      } else {
        errorMessage = "SomeThing Went Wrong!!\n";
        return null;
      }
      //-------------end error handling -------------

    } catch (error) {
      print(error); // during development cycle
      errorMessage = "SomeThing Went Wrong!!!\n";
      return null;
    }
  }
  // ------------------------------------------------------------------
}
