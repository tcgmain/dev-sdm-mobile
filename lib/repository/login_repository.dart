import 'dart:convert';
import 'package:sdm_mobile/models/login.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class LoginRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;
 
  Future<Login> getLoginData(String username, String password, String deviceId) async {

    requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    inputBody = {
      "id": "(262,77,0)",
      "ylogopr": username,
      "ylogpwd": password,
      "ylogimei": deviceId,
      "ylogver": "",
      "yerrmsg": "",
      "ypwdid": ""
    };

    final response = await _provider.post("/login", jsonEncode(inputBody), requestHeaders);
    print(jsonDecode(jsonEncode(response)));
    return Login.fromJson(response);
  }
}
