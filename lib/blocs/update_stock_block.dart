import 'dart:async';
import 'package:sdm_mobile/models/update_stock.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/update_stock_repository.dart';

class UpdateStockBloc {
  late UpdateStockRepository _updateStockRepository;
  final StreamController<Response<ProductData>> _updateStockController = StreamController<Response<ProductData>>.broadcast();

  StreamSink<Response<ProductData>> get updateStockSink => _updateStockController.sink;
  Stream<Response<ProductData>> get updateStockStream => _updateStockController.stream;

  UpdateStockBloc() {
    _updateStockRepository = UpdateStockRepository();
  }

  product(String username, String organizationName) async {
    updateStockSink.add(Response.loading('Loading...'));
    try {
      ProductData res = await _updateStockRepository.getProduct(username, organizationName);
      print("#################${res.table[0].yproddesc}"); // Ensure it prints correctly
      updateStockSink.add(Response.completed(res));
      print("Product Load SUCCESS");
    } 
    catch (e) {
      updateStockSink.add(Response.error(e.toString()));
      print("Product Load ERROR $e");
    }
  }

  dispose() {
    _updateStockController.close();
  }
}
