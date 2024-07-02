import 'dart:async';
import 'package:sdm_mobile/models/change_password.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/changw_pssword_repository.dart';

class ChangePasswordBloc {
  late ChangePasswordBlocRepository _changePasswordRepository;
  StreamController? _changePasswordController;

  StreamSink<ResponseList<ChangePassword>> get changePasswordSink => _changePasswordController!.sink as StreamSink<ResponseList<ChangePassword>>;
  Stream<ResponseList<ChangePassword>> get changePasswordStream => _changePasswordController!.stream as Stream<ResponseList<ChangePassword>>;

  // ignore: non_constant_identifier_names
  ChangePasswordBloc() {
    _changePasswordController = StreamController<ResponseList<ChangePassword>>.broadcast();
    _changePasswordRepository = ChangePasswordBlocRepository();
  }

  changePassword(String newpassword, loginId) async {
    changePasswordSink.add(ResponseList.loading(''));
    try {
      List<ChangePassword> res = await _changePasswordRepository.changeNewPassword(newpassword,loginId);
      changePasswordSink.add(ResponseList.completed(res));
      //Saving username in local storage
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String username = (prefs.getString('username')).toString();
      print("Update Pssword SUCCESSFULLY");
    } 
    catch (e) {
      changePasswordSink.add(ResponseList.error(e.toString()));
      print("Update Password FAIL $e");
    }
  }


  dispose() {
    _changePasswordController?.close();
  }
}