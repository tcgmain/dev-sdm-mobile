import 'dart:async';
import 'package:sdm_mobile/models/goods_update.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/goods_update_repository.dart';

class GoodsUpdateBloc {
  late GoodsUpdateRepository _goodsUpdateRepository;
  final StreamController<Response<GoodsUpdate>> _goodsUpdateController = StreamController<Response<GoodsUpdate>>.broadcast();

  StreamSink<Response<GoodsUpdate>> get goodsUpdateSink => _goodsUpdateController.sink;
  Stream<Response<GoodsUpdate>> get goodsUpdateStream => _goodsUpdateController.stream;

  GoodsUpdateBloc() {
    _goodsUpdateRepository = GoodsUpdateRepository();
  }

  goodsUpdate(String id, DateTime date, String productnummer, String stock , String userName) async {
    goodsUpdateSink.add(Response.loading('Loading...'));
    try {
      GoodsUpdate res = await _goodsUpdateRepository.updateStock(id,date, productnummer,stock,userName);
      print("#################${res.table}"); // Ensure it prints correctly
      goodsUpdateSink.add(Response.completed(res));
      print("Stock Update SUCCESS");
    } 
    catch (e) {
      goodsUpdateSink.add(Response.error(e.toString()));
      print("Stock Update FAIL $e");
    }
  }

  dispose() {
    _goodsUpdateController.close();
  }
}
