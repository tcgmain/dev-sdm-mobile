// ignore_for_file: library_prefixes
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:sdm_mobile/blocs/login_bloc.dart';
import 'package:sdm_mobile/models/login.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/view/home_view.dart';
import 'package:sdm_mobile/widgets/App_Button.dart';
import 'package:sdm_mobile/widgets/error_alert.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/loading.dart';
import 'package:sdm_mobile/widgets/text_field.dart' as textField;
import 'package:sdm_mobile/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;
  bool _showPassword = true;
  bool _saveCredentials = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  String deviceId = "";
  bool _dialogShown = false;

  _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> _saveCredentialsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setBool('saveCredentials', _saveCredentials);
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      _saveCredentials = prefs.getBool('saveCredentials') ?? false;
    });
  }

  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('saveCredentials');
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
    _fetchDeviceId();
    _loadCredentials();
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return null;
  }

  Future<void> _fetchDeviceId() async {
    deviceId = (await _getId())!;
    setState(() {}); // Trigger a rebuild to show the device ID
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset("images/design.jpg").image,
                  fit: BoxFit.cover)),
          child: Center(
            child: FrostedGlassBox(
              width: contWidth,
              height: contWidth * 1.4,
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: deviceInfoButton(context, deviceId),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            child: Column(
                              children: [
                                logo(context),
                                const SizedBox(
                                  height: 20,
                                ),
                                textField.TextField(
                                  controller: usernameController,
                                  obscureText: false,
                                  inputType: 'none',
                                  isRequired: true,
                                  fillColor:
                                      const Color.fromARGB(50, 255, 255, 255),
                                  filled: true,
                                  labelText: "Username",
                                  onChangedFunction: () {},
                                ),
                                const SizedBox(height: 20.0),
                                textField.TextField(
                                  controller: passwordController,
                                  obscureText: _showPassword,
                                  inputType: 'none',
                                  isRequired: true,
                                  function: _togglePasswordVisibility,
                                  fillColor:
                                      const Color.fromARGB(50, 255, 255, 255),
                                  filled: true,
                                  labelText: "Password",
                                  suffixIcon: getPasswordSuffixIcon(
                                      _togglePasswordVisibility, _showPassword),
                                  onChangedFunction: () {},
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _saveCredentials,
                                      onChanged: (value) {
                                        setState(() {
                                          _saveCredentials = value!;
                                        });
                                      },
                                      side: WidgetStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                          color: Color.fromARGB(255, 255, 255,
                                              255), // Border color
                                          width: 1.0, // Border width
                                        ),
                                      ),
                                      fillColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Colors
                                                .transparent; // Transparent fill color when selected
                                          }
                                          return Colors
                                              .transparent; // Transparent fill color when not selected
                                        },
                                      ),
                                      checkColor: const Color.fromARGB(255, 4,
                                          173, 179), // Color of the check mark
                                    ),
                                    const Text(
                                      "Save Credentials",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: loginButton(context),
                      ),
                      loginResponse(),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget logo(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.2;

    return Column(
      children: [
        SizedBox(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(0, 255, 255, 255), // Border color
                width: 0.5, // Border width
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(0.5), // Shadow color
                  spreadRadius: 20, // Spread radius
                  blurRadius: 20, // Blur radius
                  offset: const Offset(0, 0), // Offset of the shadow
                ),
              ],
              borderRadius:
                  BorderRadius.circular(15.0), // Border radius (if needed)
            ),
            child: FrostedGlassBox(
              height: contWidth,
              width: contWidth,
              border:
                  Border.all(color: Colors.white.withOpacity(0.0), width: 1.0),
              child: Opacity(
                opacity: 0.9,
                child: Image.asset('images/logo.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

//This is for pop up message
  Widget deviceInfoButton(BuildContext context, String deviceId) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.info_outline_rounded,
          color: Color.fromARGB(255, 18, 175, 167)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Device ID',
          enabled: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Device ID: $deviceId"),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  FlutterClipboard.copy(deviceId).then((result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Device ID copied to clipboard')),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget loginButton(BuildContext context) {
    return CommonAppButton(
      buttonText: "Login",
      onPressed: () async {
        setState(() {
          _dialogShown =
              false; // Reset _dialogShown state for each login attempt
        });

        String? deviceId = await _getId();
        print("THIS IS DEVICE ID:  $deviceId");

        _loginBloc.login(usernameController.text.toString(),
            passwordController.text.toString(), deviceId.toString());
        if (_saveCredentials) {
          _saveCredentialsToPrefs();
        } else {
          _clearCredentials();
        }
      },
    );
  }

  Future<void> _handleCompletedLogin(BuildContext context, loggingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logging_id', loggingId);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  Widget loginResponse() {
    return StreamBuilder<Response<Login>>(
      stream: _loginBloc.loginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loading(loadingMessage: snapshot.data!.message.toString()),
                  ],
                ),
              );
            case Status.COMPLETED:
              if (!_dialogShown) {
                _dialogShown = true;
                if (snapshot.data!.data!.ylogver == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _handleCompletedLogin(context, snapshot.data!.data!.id);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    print(snapshot.data!.data!.yerrmsg);
                    showErrorAlertDialog(context,
                            snapshot.data!.data!.yerrmsg ?? 'Unknown error')
                        .then((_) {
                      setState(() {
                        _dialogShown = false; // Reset dialog shown state
                        usernameController.clear();
                        passwordController.clear();
                      });
                    });
                  });
                }
              }
              break;
            case Status.ERROR:
              if (!_dialogShown) {
                _dialogShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(
                          context, snapshot.data!.message ?? 'Unknown error')
                      .then((_) {
                    setState(() {
                      _dialogShown = false; // Reset dialog shown state
                    });
                  });
                });
              }
              break;
          }
        }
        return Container();
      },
    );
  }
}
