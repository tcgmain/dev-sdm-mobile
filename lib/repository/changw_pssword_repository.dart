import 'dart:convert';
import 'package:sdm_mobile/models/change_password.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordBlocRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<ChangePassword>> changeNewPassword(String newpassword, loginId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? 'Guest';

    // Define request headers
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Define input body
    inputBody = {
      // Include any necessary parameters
      "id": userId,
      "ysdmpwd": newpassword
    };

    // Make the API call
    print("--------------------------------------------$inputBody");
    final response = await _provider.post(
        "/changepassword", jsonEncode(inputBody), requestHeaders);
    print(response);
    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<ChangePassword> getLogID =
        list.map((obj) => ChangePassword.fromJson(obj)).toList();
    return getLogID;
  }




}
