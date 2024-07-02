// ignore_for_file: unnecessary_cast

import 'dart:async';
import 'package:sdm_mobile/models/get_distributor.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/get_distributor_repository.dart';

class GetDistributorBloc {
  late GetDistributorRepository _getDistributorRepository;
  StreamController<ResponseList<GetDistributor>>? _getDistributorController;

  StreamSink<ResponseList<GetDistributor>> get getDistributorSink => _getDistributorController!.sink as StreamSink<ResponseList<GetDistributor>>;
  Stream<ResponseList<GetDistributor>> get getDistributorStream => _getDistributorController!.stream as Stream<ResponseList<GetDistributor>>;

  GetDistributorBloc() {
    _getDistributorController = StreamController<ResponseList<GetDistributor>>.broadcast();
    _getDistributorRepository = GetDistributorRepository();
  }

  getDistributor(String username) async {
    getDistributorSink.add(ResponseList.loading('Fetching Distributors...'));
    try {
      GetDistributor res = await _getDistributorRepository.getDistributors(username);
      getDistributorSink.add(ResponseList.completed(res as List<GetDistributor>?));
      print("Get Distributor List SUCCESSFULLY");
    } catch (e) {
      getDistributorSink.add(ResponseList.error(e.toString()));
      print("Get Distributor List FAIL $e");
    }
  }

  dispose() {
    _getDistributorController?.close();
  }
}
