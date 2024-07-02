// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:sdm_mobile/models/my_route.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class MyRouteRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  var inputBody, requestHeaders;

  Future<List<MyRoute>> getMyRoute(String username, String date) async {
    requestHeaders = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};

    inputBody = {"ysdmem^such": username, "ypldate": date};

    final response = await _provider.post("/getrouteassignment", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<MyRoute> myRoute = list.map((obj) => MyRoute.fromJson(obj)).toList();
    return myRoute;
  }
}
