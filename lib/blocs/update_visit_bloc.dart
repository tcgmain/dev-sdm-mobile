import 'dart:async';
import 'package:sdm_mobile/models/update_visit.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/update_visit_repository.dart';

class UpdateVisitBloc{
  late UpdateVisit _updateVisitRepository;
  StreamController? _updateVisitController;

  StreamSink<ResponseList<UpdateVisits>> get updateVisitSink => _updateVisitController!.sink as StreamSink<ResponseList<UpdateVisits>>;
  Stream<ResponseList<UpdateVisits>> get updateVisitStream => _updateVisitController!.stream as Stream<ResponseList<UpdateVisits>>;

  UpdateVisitBloc() {
    _updateVisitController = StreamController<ResponseList<UpdateVisits>>.broadcast();
    _updateVisitRepository = UpdateVisit();
  }
  
  //Getting update visit response
  updatevisit(String visit, String username, String organization,String route,String date,String time) async {
    updateVisitSink.add(ResponseList.loading(''));
    try {
      List<UpdateVisits> res = await _updateVisitRepository.updateVist(visit, username, organization,route,date,time);
      print("#############################################################");
      updateVisitSink.add(ResponseList.completed(res));
      print("VISIT UPDATE SUCCESS");
    } catch (e) {
      updateVisitSink.add(ResponseList.error(e.toString()));
      print("VISIT UPDATE ERROR");
    }
  }

  dispose() {
    _updateVisitController?.close();
  }
}