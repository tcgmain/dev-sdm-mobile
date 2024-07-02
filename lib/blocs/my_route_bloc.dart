import 'dart:async';
import 'package:sdm_mobile/models/my_route.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/my_route_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRouteBloc {
  late MyRouteRepository _myRouteRepository;
  StreamController? _myRouteController;

  StreamSink<ResponseList<MyRoute>> get myRouteSink => _myRouteController!.sink as StreamSink<ResponseList<MyRoute>>;
  Stream<ResponseList<MyRoute>> get myRouteStream => _myRouteController!.stream as Stream<ResponseList<MyRoute>>;

  MyRouteBloc() {
    _myRouteController = StreamController<ResponseList<MyRoute>>.broadcast();
    _myRouteRepository = MyRouteRepository();
  }

  getMyRoute(String selectedDate) async {
    myRouteSink.add(ResponseList.loading(''));
    try {
      //Getting username from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName = (prefs.getString('username')).toString();

      List<MyRoute> res = await _myRouteRepository.getMyRoute(userName.toUpperCase(), selectedDate);
      myRouteSink.add(ResponseList.completed(res));
      print("ROUTE SUCCESS");
    } catch (e) {
      myRouteSink.add(ResponseList.error(e.toString()));
      print("ROUTE ERROR");
      print(e);
    }
  }

  dispose() {
    _myRouteController?.close();
  }
}
