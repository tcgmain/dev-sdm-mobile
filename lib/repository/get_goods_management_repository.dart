import 'dart:convert';
import 'package:sdm_mobile/models/get_good_management_id.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class GetGoodManagementIdRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

Future<List<GetGoodManagementID>> getGoodManagementID(organizationNummer) async {
  // Define request headers
  requestHeaders = <String, String> {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Define input body
  inputBody = {
    // Include any necessary parameters
    "yorg^nummer": organizationNummer,
  };
  print("--------------------$inputBody");
  // Make the API call
  final response = await _provider.post("/getgmid",jsonEncode(inputBody),requestHeaders);
  var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<GetGoodManagementID> getGoodMgt = list.map((obj) => GetGoodManagementID.fromJson(obj)).toList();
    return getGoodMgt;
  }
}