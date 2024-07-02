import 'dart:convert';
import 'package:sdm_mobile/models/mark_visit.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class MarkVisitRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

Future<List<Organization>> getOrganization(username) async {
  // Define request headers
  requestHeaders = <String, String> {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Define input body
  inputBody = {
    // Include any necessary parameters
    "yassigto": username,
  };
  // Make the API call
  final response = await _provider.post("/getorganization",jsonEncode(inputBody),requestHeaders);

  

  var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Organization> myRoute = list.map((obj) => Organization.fromJson(obj)).toList();
    return myRoute;
  }
}
