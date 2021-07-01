import 'dart:convert';
import 'dart:async';

import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import './directions.dart';

class DirectionsRepository {
  String errorMessage = '';

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    Uri apiLink = Uri.https(
      'maps.googleapis.com',
      '/maps/api/directions/json',
      {
        'key': Map_Key,
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}'
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
        return Directions.fromMap(responseData);
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
