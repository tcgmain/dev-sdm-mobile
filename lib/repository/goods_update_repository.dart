import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sdm_mobile/models/goods_update.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'dart:async';

class GoodsUpdateRepository {
  final ApiProvider _provider = ApiProvider();

  Future<GoodsUpdate> updateStock(String id, DateTime date, String productnummer, String stock , String userName) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    Map<String, dynamic> inputBody = {
      "id": id,
      "table": [
        {
        "yentdat": formattedDate, //Entry Date 
        "yprod": productnummer, //Product Code 
        "ycurstoc": stock, //Current Stock 
        "yrecqty": "100", //Reciept Quantity 
        "yissqty": "12", //Issue Quantity 
        "yvis": "171", //Visit 
        "yuser": userName//User
        }
      ]
    };

    try {
      print("Sending request to update stock with data: $inputBody");
      final response = await _provider.post("/updateStock", jsonEncode(inputBody), requestHeaders);
      print("Response from updateStock: $response");
      return GoodsUpdate.fromJson(response);
    } catch (e) {
      print("Error updating stock: $e");
      throw Exception('Stock Update FAIL: $e');
    }
  }
}

