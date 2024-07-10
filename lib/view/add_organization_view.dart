// ignore_for_file: file_names, library_prefixes, unused_element
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sdm_mobile/blocs/add_organization_bloc.dart';
import 'package:sdm_mobile/blocs/get_distributor_bloc.dart';
import 'package:sdm_mobile/models/get_distributor.dart';
import 'package:sdm_mobile/networking/api_provider.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/home_view1.dart';
import 'package:sdm_mobile/widgets/app_button.dart';
import 'package:sdm_mobile/widgets/appbar.dart';
import 'package:sdm_mobile/widgets/custom_text_field.dart';
import 'package:sdm_mobile/widgets/error_alert.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';

enum ButtonState { init, loading, done }

class AddOrganizationPage extends StatefulWidget {
  const AddOrganizationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddOrganizationPageState createState() => _AddOrganizationPageState();
}

late double latitude1;
late double longitude1;
double _latitude = 0.0;
double _longitude = 0.0;

class _AddOrganizationPageState extends State<AddOrganizationPage> {
  // Constructor to initialize the color
  String selectCountry = "select country";
  String finalTextToBeDisplayed = "";
  // bool isDataLoaded = false;
  late AddOrganizationBloc _addOrganizationBloc;
  late String _name;
  late String _searchWord;
  var nameController = TextEditingController();
  var dealerController = TextEditingController();
  var emailController = TextEditingController();
  var phone1Controller = TextEditingController();
  var phone2Controller = TextEditingController();
  var addresline1Controller = TextEditingController();
  var addresline2Controller = TextEditingController();
  var addresline3Controller = TextEditingController();
  var addresline4Controller = TextEditingController();

  late bool? _inventory = false;
  late bool? _selfDeliver = false;
  late bool? _selfReciver = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GetDistributorBloc _getDistributorBloc;
  String username = "ASHEN_IT";
  String? selectedDealer;
  List<GetDistributor> dealers = [];


  Future<Position> _determinePosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled return an error message
      return Future.error('Location services are disabled.');
    }
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, return the current location
    return await Geolocator.getCurrentPosition();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude1 = position.latitude;
        longitude1 = (position.longitude);
        _latitude = double.parse(latitude1.toStringAsFixed(6));
        _longitude = double.parse(longitude1.toStringAsFixed(6));
        print(
          _latitude,
        );
        print(
          _longitude,
        );
      });
    } catch (e) {
      print("Error : $e");
    }
  }

void _successDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: CustomColors.abasColor,
        ),
      );
    },
  );

  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pop(context); // Close the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Organization Created!"),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage1()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  });
}

  @override
  void initState() {
    super.initState();
    _addOrganizationBloc = AddOrganizationBloc();
    _getDistributorBloc = GetDistributorBloc();
    _getCurrentLocation();
   // getCountry();
    _initializeData(); // Initialize your bloc here
  }

  Future<void> _initializeData() async {
    _getDistributorBloc.getDistributor(username);
    _getDistributorBloc.getDistributorStream.listen((response) {
      if (response.status == Status.COMPLETED) {
        setState(() {
          dealers = response.data!;
        });
      } else if (response.status == Status.ERROR) {
        print('Error: ${response.message}');
      }
    });
  }

    @override
      void dispose() {
       _getDistributorBloc.dispose();
      super.dispose();
  }

  Widget _buildName() {
    return CustomTextField(
      labelText: "Name",
      controller: nameController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Name is required";
        }
        return null;
      },
      onSaved: (String? value) {
        _name = value ?? '';
        String convertToNoSpaceString(String input) {
          return input.replaceAll(' ', '_');
        }

        _searchWord = convertToNoSpaceString(_name);
      },
    );
  }

  Widget _buildDealer() {
    return DropdownButtonFormField<String>(
      value: selectedDealer,
      items: dealers.map((GetDistributor dealer) {
        return DropdownMenuItem<String>(
          value: dealer.namebspr,
          child: Text(dealer.namebspr ?? ''),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedDealer = newValue;
        });
      },
      decoration: const InputDecoration(
        labelText: "Dealer's Name",
        border: OutlineInputBorder(),
      ),
    );
  }



  Widget _buildemail() {
    return CustomTextField(
      labelText: "Email",
      controller: emailController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
        }
        return null;
      },
      onSaved: (String? value) {},
    );
  }

  Widget _buildphone1() {
    return CustomTextField(
      labelText: "Phone 1",
      controller: phone1Controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Phone 1 is required";
        }
        return null;
      },
      onSaved: (String? value) {},
    );
  }

  Widget _buildphone2() {
    return CustomTextField(
      labelText: "Phone 2",
      controller: phone2Controller,
      onSaved: (String? value) {},
    );
  }

  Widget _buildaddres1() {
    return CustomTextField(
      labelText: "Addres Line 1",
      controller: addresline1Controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Addres Line 1 is required";
        }
        return null;
      },
      onSaved: (String? value) {},
    );
  }

  Widget _buildaddres2() {
    return CustomTextField(
      labelText: "Addres Line 2",
      controller: addresline2Controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Addres Line 2 is required";
        }
        return null;
      },
      onSaved: (String? value) {},
    );
  }

  Widget _buildaddres3() {
    return CustomTextField(
      labelText: "Addres Line 3",
      controller: addresline3Controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Addres Line 3 is required";
        }
        return null;
      },
      onSaved: (String? value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/design.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CommonAppBar(
                title: 'Add Organization',
                onBackButtonPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage1()),
                    (Route<dynamic> route) => false,
                  ));
                },
                userName: '',
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 80), // Adjust this value to create a gap between the app bar and glass box
                      FrostedGlassBox(
                        width: contWidth,
                        height: contWidth * 1.75,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width : 1.0),
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Form(
                                  key: _formKey,
                                  child: ListView(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _buildName(),
                                      _buildemail(),
                                      _buildphone1(),
                                      _buildphone2(),
                                      _buildaddres1(),
                                      _buildaddres2(),
                                      _buildaddres3(),
                                      const SizedBox(height: 5),
                                      _buildDealer(),
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              const Text("Manage Inventory", style: TextStyle(color: Colors.white)),
                                              Checkbox(
                                                value: _inventory,
                                                checkColor: const Color.fromARGB(255, 4, 173, 179),
                                                activeColor: const Color.fromARGB(255, 174, 250, 244),
                                                onChanged: (newBool) {
                                                  setState(() {
                                                    _inventory = newBool!;
                                                  });
                                                },
                                                side: WidgetStateBorderSide.resolveWith(
                                                  (states) => const BorderSide(
                                                    color: Color.fromARGB(255, 255, 255, 255), // Border color
                                                    width: 2.0, // Border width
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 15),
                                          Column(
                                            children: <Widget>[
                                              const Text("Self Deliver", style: TextStyle(color: Colors.white)),
                                              Checkbox(
                                                value: _selfDeliver,
                                                checkColor: CustomColors.abasColor,
                                                activeColor: const Color.fromARGB(255, 174, 250, 244),
                                                onChanged: (newBool) {
                                                  setState(() {
                                                    _selfDeliver = newBool!;
                                                  });
                                                },
                                                side: WidgetStateBorderSide.resolveWith(
                                                  (states) => const BorderSide(
                                                    color: Color.fromARGB(255, 255, 255, 255), // Border color
                                                    width: 2.0, // Border width
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            children: <Widget>[
                                              const Text("Self Receive", style: TextStyle(color: Colors.white)),
                                              Checkbox(
                                                value: _selfReciver,
                                                checkColor: CustomColors.abasColor,
                                                activeColor: const Color.fromARGB(255, 174, 250, 244),
                                                onChanged: (newBool) {
                                                  setState(() {
                                                    _selfReciver = newBool!;
                                                  });
                                                },
                                                side: WidgetStateBorderSide.resolveWith(
                                                  (states) => const BorderSide(
                                                    color: Color.fromARGB(255, 255, 255, 255), // Border color
                                                    width: 2.0, // Border width
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          CommonAppButton(
                                            buttonText: "Submit",
                                            onPressed: () async {
                                              _getCurrentLocation();
                                              if (!_formKey.currentState!.validate()) {
                                                return;
                                              }
                                              _formKey.currentState?.save();
                                              _addOrganizationBloc.organization(
                                                _name.toString(),
                                                _searchWord.toString(),
                                                dealerController.text.toString(),
                                                emailController.text.toString(),
                                                phone1Controller.text.toString(),
                                                phone2Controller.text.toString(),
                                                addresline1Controller.text.toString(),
                                                addresline2Controller.text.toString(),
                                                addresline3Controller.text.toString(),
                                                _latitude.toString(),
                                                _longitude.toString(),
                                                _inventory.toString(),
                                                _selfDeliver.toString(),
                                                _selfReciver.toString()
                                              );

                                              if (flag1 == true) {
                                                nameController.clear();
                                                dealerController.clear();
                                                emailController.clear();
                                                phone1Controller.clear();
                                                phone2Controller.clear();
                                                addresline1Controller.clear();
                                                addresline2Controller.clear();
                                                addresline3Controller.clear();
                                                _successDialog(context);
                                              } else {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  showErrorAlertDialog(context, "There is some issue. please try again!!");
                                                });
                                              }
                                            },
                                          ),
                                          const SizedBox(width: 40),
                                          CommonAppButton(
                                            buttonText: "Cancel",
                                            onPressed: () async {
                                              nameController.clear();
                                              dealerController.clear();
                                              emailController.clear();
                                              phone1Controller.clear();
                                              phone2Controller.clear();
                                              addresline1Controller.clear();
                                              addresline2Controller.clear();
                                              addresline3Controller.clear();
                                              setState(() {
                                                _inventory = false;
                                                _selfDeliver = false;
                                                _selfReciver = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Latitude: $_latitude",
                                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                          ),
                                          Text(
                                            "Longitude: $_longitude",
                                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                          ),
                                          const SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
