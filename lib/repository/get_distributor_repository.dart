import 'dart:convert';
import 'package:sdm_mobile/models/get_distributor.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class GetDistributorRepository {
  final ApiProvider _provider = ApiProvider();

  Future<GetDistributor> getDistributors(String username) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    Map<String, dynamic> inputBody = {
      "yassigto": username,
      "ycustyp": "Distributor"
    };
    final response = await _provider.post("/getcustypeorganization", jsonEncode(inputBody), requestHeaders);
    return GetDistributor.fromJson(json.decode(response));

  }
}
