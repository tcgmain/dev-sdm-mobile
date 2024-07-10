// ignore_for_file: prefer_typing_uninitialized_variables

import 'custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

bool flag1 = false;

class ApiProvider {
  //Common URL of API calls
  var baseUrl = "http://192.168.100.33:1246";
  Future<dynamic> post(String url, inputBody, requestHeaders) async {
    var responseJson;
    try {
      print(baseUrl+url);
      final response = await http.post(Uri.parse(baseUrl + url), headers: requestHeaders, body: inputBody);
      String responseString = response.body.toString();
      //responseString = convertToJson(responseString
    print(responseString);
      responseJson = _response(jsonDecode(responseString), response.statusCode);
      //print(responseJson.toString());
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  // String convertToJson(String str) {
  //   str = str.toString().replaceAll('=', '": "');
  //   str = str.replaceAll('{', '{"');
  //   str = str.replaceAll(', ', '", "');
  //   str = str.replaceAll('}', '"}');
  //   str = str.replaceAll('"[{', '[{');
  //   str = str.replaceAll('}]"', '}]');
  //   str = str.replaceAll('}"', '}');
  //   str = str.replaceAll('"{', '{');
  //   return str;
  // }

  dynamic _response(response, statusCode) {
    print(response);
    print(statusCode);
    switch (statusCode) {
      case 200:
        if (response["success"] == true) {
          flag1 = true;
          print(flag1);
          return response["result_data"];
        }
        // else if (response["success"] == "true" && response["result_data"] == "[]") {
        //   throw NotFound("404");
        // }
        else {
          throw AbasException(response["message"]);
        }
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error with StatusCode : ${response.statusCode}');
    }
  }
}
