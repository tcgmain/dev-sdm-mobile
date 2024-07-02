import 'dart:async';
import 'package:sdm_mobile/models/route_organization.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/route_organization_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteOrganizationBloc {
  late RouteOrganizationRepository _routeOrganizationRepository;
  StreamController? _routeOrganizationController;

  StreamSink<ResponseList<RouteOrganization>> get routeOrganizationSink =>
      _routeOrganizationController!.sink as StreamSink<ResponseList<RouteOrganization>>;
  Stream<ResponseList<RouteOrganization>> get routeOrganizationStream =>
      _routeOrganizationController!.stream as Stream<ResponseList<RouteOrganization>>;

  RouteOrganizationBloc() {
    _routeOrganizationController = StreamController<ResponseList<RouteOrganization>>.broadcast();
    _routeOrganizationRepository = RouteOrganizationRepository();
  }

  //Getting organization response
  getRouteOrganization() async {
    routeOrganizationSink.add(ResponseList.loading(''));
    try {
      //Getting route organization list nummer from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String nummer = (prefs.getString('yplroute^nummer')).toString();

      List<RouteOrganization> res = await _routeOrganizationRepository.getRouteOrganization(nummer);
      routeOrganizationSink.add(ResponseList.completed(res));

      print("ROUTE ORGANIZATION SUCCESS");
    } catch (e) {
      routeOrganizationSink.add(ResponseList.error(e.toString()));
      print("ROUTE ORGANIZATION ERROR");
      print(e);
    }
  }

  dispose() {
    _routeOrganizationController?.close();
  }
}
