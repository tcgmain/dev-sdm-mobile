import 'dart:convert';
import 'package:sdm_mobile/models/update_stock.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class UpdateStockRepository {
  final ApiProvider _provider = ApiProvider();

  Future<ProductData> getProduct(String username, String organizationNummer) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> inputBody = {
      "id": "(310,77,0)",
      "ysdmemp": username,
      "ysdmorg": organizationNummer,
      "table": [
        {"yprodnummer": "", 
        "yprodsuch": "", 
        "yproddesc": "",
        "ycurstoc": ""
        }
      ]
    };

    final response = await _provider.post("/getproduct", jsonEncode(inputBody), requestHeaders);
    return ProductData.fromJson(response);
  }
}

