import 'dart:convert';
import 'package:sdm_mobile/models/update_visit.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class UpdateVisit {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;
 
  Future<List<UpdateVisits>> updateVist(String visit,String username, String organiz,String route,String date,String time) async {

    requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    inputBody = <String, String>{ 
      "such"     : "visit", //Search word is added temporary 
      "ysdmempv" : username, //SDM Employee 
      "yorg"     : organiz, //SDM Organization 
      "yvrout"   : route, //Route 
      "yvdat"    : date, //Visit Date
      "yvtim"    : time //Visit Time
    };
    print(inputBody);
    final response = await _provider.post("/updatevisit", jsonEncode(inputBody), requestHeaders);
    print(response);
    
    var list = [];
    for (var i = 0; i < response.length; i++) {
      list.add(response[i]);
    }

    List<UpdateVisits> updateVistData = list.map((obj) => UpdateVisits.fromJson(obj)).toList();
    return updateVistData;
  }
}