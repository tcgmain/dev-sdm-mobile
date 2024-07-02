// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sdm_mobile/blocs/change_password_bloc.dart';
import 'package:sdm_mobile/models/change_password.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/home_view.dart';
import 'package:sdm_mobile/view/login_view.dart';
import 'package:sdm_mobile/widgets/app_button.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBarHome extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;

  const CommonAppBarHome({
    super.key,
    required this.title,
    required this.onBackButtonPressed, required String userName,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBarHome> {
  String? username;
  String? loggingId;
  final TextEditingController changepassdControl = TextEditingController();
  late ChangePasswordBloc _changePassBloc;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    changepassdControl.addListener(_validateInput);
    _getUsername();
    _getLoggingId();
    _changePassBloc = ChangePasswordBloc();
  }

  Future<void> _getLoggingId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggingId = prefs.getString('logging_id');
    });
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> changePasswordDialog(loggingId) async {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0, // This sets the dialog to be transparent
          child: FrostedGlassBoxForMessages(
            width: contWidth,
            height: contWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Hi $username",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: changepassdControl,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color.fromARGB(255, 255, 255, 255), // Set the cursor color
                    decoration: const InputDecoration(
                      labelText: 'Type New Password',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255), 
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)), // Set the line color when the field is not focused
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 209, 162, 9)), // Set the line color when the field is focused
                      ),
                    ),
                    onChanged: (value) {
                      print("New Password: $value");
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    CommonAppButton(
                      buttonText: "   OK   ",
                      onPressed: () {
                        String inputValue = changepassdControl.text;
                        if (inputValue.isEmpty) {
                          _showErrorDialog(context);
                        } else {
                          _changePassBloc.changePassword(inputValue, loggingId);
                          //changePasswordResponse();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 10,),
                    CommonAppButton(
                      buttonText: "Cancel",
                      onPressed: () => {
                        changepassdControl.clear(),
                        Navigator.of(context).pop(),
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:false, 
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: CustomColors.abasColor,
          ), // Loading indicator
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      // Close the loading dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Change Password Error"),
            content: const Text(
              "Please Enter Letters, Numbers, _ , @, #,&, only",
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok")),
            ],
          );
        },
      );
    });
  }

  void _validateInput() {
    final validCharacters = RegExp(r'^[a-zA-Z0-9_@#&]*$');
    String currentText = changepassdControl.text;
    if (!validCharacters.hasMatch(currentText)) {
      changepassdControl.value = changepassdControl.value.copyWith(
        text: currentText.replaceAll(RegExp(r'[^a-zA-Z0-9_@#&]'), ''),
        selection: TextSelection.fromPosition(
          TextPosition(offset: changepassdControl.text.length),
        ),
      );
    }
  }

  Widget changePasswordResponse() {
    return StreamBuilder<ResponseList<ChangePassword>>(
      stream: _changePassBloc.changePasswordStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Loading...'),
                  ],
                ),
              );
            case Status.COMPLETED:
              if (!_dialogShown) {
                _dialogShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  successDialog(context, "Change Password Successfully");
                });
              }
              break;
            case Status.ERROR:
              if (!_dialogShown) {
                _dialogShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, "One or more passwords failed to change.");
                });
              }
              break;
            default:
              return Container();
          }
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        return Container();
      },
    );
  }

  void showErrorAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void successDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    changepassdControl.removeListener(_validateInput);
    changepassdControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0), 
        bottomRight: Radius.circular(20.0), 
      ),
      child: AppBar(
        foregroundColor:   const Color.fromARGB(255, 6, 235, 243).withOpacity(1),
        backgroundColor: const Color.fromARGB(101, 32, 188, 165),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              ));
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'logout') {
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                ));
              } else if (result == "Change Password") {
                _dialogShown = false;
                changePasswordDialog(loggingId);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'userName',
                enabled: false,
                child: Text(username ?? ''),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
              const PopupMenuItem<String>(
                value: 'Change Password',
                child: Text('Change Password'),
              ),
            ],
             child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 2, 2, 2), // Set your desired background color here
                  borderRadius: BorderRadius.circular(20), // Optional: Add rounded corners
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Optional: Adjust padding
                child: const Icon(Icons.more_vert, color:   Color.fromARGB(255, 6, 235, 243),), // Customize icon if needed
              ),
          ),
          changePasswordResponse(),
        ],
      ),
    );
  }
}
