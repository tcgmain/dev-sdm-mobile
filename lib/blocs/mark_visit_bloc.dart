import 'dart:async';
import 'package:sdm_mobile/models/mark_visit.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/mark_visit_repository.dart';

class MarkVisitBloc {
  late MarkVisitRepository _markVisitRepository;
  StreamController? _markVisitController;

  StreamSink<ResponseList<Organization>> get markVisitSink => _markVisitController!.sink as StreamSink<ResponseList<Organization>>;
  Stream<ResponseList<Organization>> get markVisitStream => _markVisitController!.stream as Stream<ResponseList<Organization>>;

  MarkVisitBloc() {
    _markVisitController = StreamController<ResponseList<Organization>>.broadcast();
    _markVisitRepository = MarkVisitRepository();
  }

  visits(String username) async {
    markVisitSink.add(ResponseList.loading(''));
    try {
      List<Organization> res = await _markVisitRepository.getOrganization(username);
      markVisitSink.add(ResponseList.completed(res));
      //Saving username in local storage
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String username = (prefs.getString('username')).toString();
      print("Visit SUCCESS");
    } 
    catch (e) {
      markVisitSink.add(ResponseList.error(e.toString()));
      print("Visit ERROR $e");
    }
  }


  dispose() {
    _markVisitController?.close();
  }
}