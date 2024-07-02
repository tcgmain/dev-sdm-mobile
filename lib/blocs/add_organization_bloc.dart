// ignore_for_file: file_names

import 'dart:async';
import 'package:sdm_mobile/models/add_organization.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/add_organization_repository.dart';

class AddOrganizationBloc{
  late AddOrganization _addOrgRepository;
  StreamController? _addOrgController;

  StreamSink<ResponseList<AddOrganizations>> get addOrgSink => _addOrgController!.sink as StreamSink<ResponseList<AddOrganizations>>;
  Stream<ResponseList<AddOrganizations>> get addOrgStream => _addOrgController!.stream as Stream<ResponseList<AddOrganizations>>;

  AddOrganizationBloc() {
    _addOrgController = StreamController<ResponseList<AddOrganizations>>.broadcast();
    _addOrgRepository = AddOrganization();
  }
  
  //Getting login response
  organization(String name, String searchWord, String dealer,String email,String phone1,String phone2,String addres1,String addres2, String addres3, String latitude, String longitude, String inventory, String selfDeliver, String selfReciver,) async {
    addOrgSink.add(ResponseList.loading(''));
    try {
      List<AddOrganizations> res = await _addOrgRepository.getaddOrganization(name, searchWord,dealer,email,phone1,phone2,addres1,addres2,addres3,latitude,longitude, inventory,selfDeliver,selfReciver);
      addOrgSink.add(ResponseList.completed(res));
      print("SUBMIT SUCCESS");
    } catch (e) {
      addOrgSink.add(ResponseList.error(e.toString()));
      print("SUBMIT ERROR");
    }
  }

  dispose() {
    _addOrgController?.close();
  }
}