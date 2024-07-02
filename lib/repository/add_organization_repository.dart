import 'dart:convert';
import 'package:sdm_mobile/models/add_organization.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class AddOrganization {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;
 
  Future<List<AddOrganizations>> getaddOrganization(String name,String searchWord,String dealer,String email,String phone1,String phone2,String addres1, String addres2, String addres3, String latitude, String longitude, String inventory, String selfDeliver, String selfReciver) async {

    requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    inputBody = <String, String>{
      "namebspr"  : name,
      "such"      : searchWord,
      "yemail"    : email,
      "yphone1"   : phone1,
      "yphone2"   : phone2,
      "yaddressl1": addres1,
      "yaddressl2": addres2,
      "yaddressl3": addres3,
      "yaddressl4": "Sri Lanka",
      "ygpslat"   : latitude,
      "ygpslon"   : longitude,
      "ymnginv"   : inventory,
      "yselrec"   : selfDeliver,
      "yactiv"    : selfReciver,
    };
  
    final response = await _provider.post("/addorganization?httpMethodRestrict=POST", jsonEncode(inputBody), requestHeaders);
    
    var list = [];
    for (var i = 0; i < response.length; i++) {
      list.add(response[i]);
    }

    List<AddOrganizations> addOrganizationData = list.map((obj) => AddOrganizations.fromJson(obj)).toList();
    return addOrganizationData;
  }
}