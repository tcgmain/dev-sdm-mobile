import 'dart:async';
import 'package:sdm_mobile/models/get_good_management_id.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/get_goods_management_repository.dart';

class GetGoodMangementIdBloc {
  late GetGoodManagementIdRepository _getGoodManagementIdRepository;
  StreamController? _getGoodManagementIdController;

  StreamSink<ResponseList<GetGoodManagementID>> get getGoodManagementIdSink => _getGoodManagementIdController!.sink as StreamSink<ResponseList<GetGoodManagementID>>;
  Stream<ResponseList<GetGoodManagementID>> get getGoodManagementIdStream => _getGoodManagementIdController!.stream as Stream<ResponseList<GetGoodManagementID>>;

  // ignore: non_constant_identifier_names
  GetGoodMangementIdBloc() {
    _getGoodManagementIdController = StreamController<ResponseList<GetGoodManagementID>>.broadcast();
    _getGoodManagementIdRepository = GetGoodManagementIdRepository();
  }

  getID(String organizationNummer) async {
    getGoodManagementIdSink.add(ResponseList.loading(''));
    try {
      List<GetGoodManagementID> res = await _getGoodManagementIdRepository.getGoodManagementID(organizationNummer);
      getGoodManagementIdSink.add(ResponseList.completed(res));
      //Saving username in local storage
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String username = (prefs.getString('username')).toString();
      print("Get Good Management ID SUCCESSFULLY");
    } 
    catch (e) {
      getGoodManagementIdSink.add(ResponseList.error(e.toString()));
      print("Get Good Management ID FAIL $e");
    }
  }


  dispose() {
    _getGoodManagementIdController?.close();
  }
}