import 'dart:core';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sdm_mobile/blocs/update_visit_bloc.dart';
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/mark_visit_home.dart';
import 'package:sdm_mobile/view/view_stock.dart';
import 'package:sdm_mobile/widgets/app_button.dart';
import 'package:sdm_mobile/widgets/date_picker_calender.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/home_app_bar.dart';
import 'package:sdm_mobile/widgets/organization_colors.dart';
import 'dart:math' as math;

class OraganizationHomePage1 extends StatefulWidget {
  final String routeName;
  final String routeNumber;
  final String organizationNummer;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationAddress3;
  final String organizationAddress4;
  final String organizationColour;
  final String organizationLongitude;
  final String organizationLatitude;
  final String organizationDistance;
  final String organizationName;
  const OraganizationHomePage1({
    Key? key,
    required this.routeName,
    required this.routeNumber,
    required this.organizationNummer,
    required this.organizationPhone1,
    required this.organizationPhone2,
    required this.organizationAddress1,
    required this.organizationAddress2,
    required this.organizationAddress3,
    required this.organizationAddress4,
    required this.organizationColour,
    required this.organizationLongitude,
    required this.organizationLatitude,
    required this.organizationDistance,
    required this.organizationName,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OraganizationHomePage1State createState() => _OraganizationHomePage1State();
}

class _OraganizationHomePage1State extends State<OraganizationHomePage1> {
  DateTime _selectedDate = DateTime.now();
  late UpdateVisitBloc _updateVisitBloc;
  String _locationMessage1 = "";

  late String organizationNummer;
  late String organizationName;
  late String routeName;
  late String routeNumber;

  String _latitude = '0.0';
  String _longitude = '0.0';
  // ignore: non_constant_identifier_names

  @override
  void initState() {
    super.initState();
    organizationNummer = widget.organizationNummer;
    organizationName =widget.organizationName;
    routeName = widget.routeName;
    routeNumber = widget.routeNumber;
    _updateVisitBloc = UpdateVisitBloc();
    _determinePosition();
  }

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return CustomDatePickerDialog(
        selectedDate: _selectedDate,
        onDateSelected: (DateTime date) {
          Navigator.of(context).pop(date);
        },
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        color1: [
          const Color.fromARGB(131, 255, 255, 255).withOpacity(0.4),
          const Color.fromARGB(90, 228, 168, 5).withOpacity(0.4),
        ],
      );
    },
  );

  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
    });
  }
}
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      setState(() {
        _locationMessage1 = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage1 = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage1 = "Location permissions are permanently denied.";
      });
      return;
    }
    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
       desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _latitude = position.latitude.toStringAsFixed(8);
      _longitude = position.longitude.toStringAsFixed(8);
      print(_latitude);
    });

    double orgLatitude = double.parse(widget.organizationLatitude);
    double orgLongitude = double.parse(widget.organizationLongitude);

    double distance = _calculateDistance(
      // position.latitude,
      // position.longitude,
      6.90090090,
      79.85781297,
      orgLatitude,
      orgLongitude,
    );

    double thresholdDistance = double.parse(widget.organizationDistance);
    setState(() {
      if (distance <= (thresholdDistance)) {
        _locationMessage1 = "\nYou are within the ${thresholdDistance}m range.";
      } else {
        _locationMessage1 = "\nYou are outside the ${thresholdDistance}m range.";
        _outofrangeDialogBox(context);
      }
    });
  } 

  void _showLocationServiceDialog() {
    _showLoadingDialog();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Remove the loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text("Please enable location services in your device settings."),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; // Earth radius in meters

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  Widget geovalidation(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Use Column to arrange children vertically
        children: [
          Text(
            _locationMessage1,
            style: const TextStyle(color: CustomColors.abasColor),
          ),
        ],
      ),
    );
  }

  Widget geolocation(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Use Column to arrange children vertically
        children: [
          Text(
            "Latitude : $_latitude",
            style: const  TextStyle(color: CustomColors.abasColor),
          ),
          Text(
            "Longitude : $_longitude",
            style: const TextStyle(color: CustomColors.abasColor),
          ),
        ],
      ),
    );
  }

  void _outofrangeDialogBox(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the loading dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: CustomColors.abasColor,
          ), // Loading indicator
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      // Close the loading dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Warning!"),
            content: const Text("Your Out Of Range!"),
            actions: [
              MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Ok")),
            ],
          );
        },
      );
    });
  }

  void _successDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the loading dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(118, 188, 178, 32),
          ), // Loading indicator
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // Use StatefulBuilder to handle state changes within the dialog
          return StatefulBuilder(
            builder: (context, setState) {
              // Start a delayed future inside the dialog builder
              Future.delayed(const Duration(seconds: 2), () {
                String orgnName = widget.organizationName;
                String orgnNummer = widget.organizationNummer;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarkVisitHome(
                      organizationName: orgnName,
                      organizationNummer: orgnNummer,
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
              });

              return Material(
                  color: Colors.transparent, // Set background color to transparent
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                          const Color.fromARGB(255, 185, 168, 8).withOpacity(0.5)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const AlertDialog(
                      backgroundColor: Colors.transparent, // Transparent dialog background
                      title:  Text("Success", style: TextStyle(color: Colors.white)),
                      content:  Text("Visit Marked Successfully!", style: TextStyle(color: Colors.white)),
                    ),
                  ),
              );
            },
          );
        },
      );
   });
}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;
    return SafeArea(
      child: Scaffold(
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
          
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FrostedGlassBox(
                width: contWidth,
                height: contWidth * 1.7,
                border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width : 1.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric( horizontal: 10, vertical: 35),
                        child: SingleChildScrollView(
                          child: Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          CommonAppButton(
                                            onPressed: () async {
                                              _selectDate(context);
                                            },
                                            buttonText: 'Select Date',
                                            
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Name        : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationName,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Phone1     : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationPhone1,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Phone2     : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationPhone2,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Address1  : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationAddress1,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Address2  : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationAddress2,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Address3  : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationAddress3,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Address4  : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.organizationAddress4,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Colour       : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                const SizedBox(width: 20),
                                                ColorPatch(colorValue: widget.organizationColour),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Route Name   : ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.routeName,
                                                    style: const TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      markVisit(context),
                                      const SizedBox(height: 10),
                                      viewStock(context),
                                      const SizedBox(height: 10),
                                      geovalidation(context),
                                      geolocation(context)
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
       Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CommonAppBarHome(
              title: organizationName,
              onBackButtonPressed: () {
                // Implement back button functionality
              },
              userName: '',
            ),
          ),
        ],
      )),
    );
  }
  
  Widget markVisit(BuildContext context) {
    String visit = "VISIT5";
    String date = DateFormat('dd/MM/yyyy').format(_selectedDate);
    //String orgName = widget.organizationName;
    final String currentTime = DateFormat('HH:mm').format(DateTime.now());
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 20),
      child: ButtonTheme(
        child: CommonAppButton(
          onPressed: () async {
            String username = await getUsername();
            //  print("--------------------------$routeName");
            //  print("..............................$username");
            if (_latitude == "0.0" && _longitude == "0.0") {
              _showErrorDialog(context);
            } else {
              _updateVisitBloc.updatevisit(visit, username, organizationNummer, routeNumber, date, currentTime);
              _successDialog(context);
            }
          },
          buttonText: "Mark Visit",
        ),
     ),
    );
  }

  Widget viewStock(BuildContext context) {
    // String visit = "VISIT5";
    // String date = DateFormat('dd/MM/yyyy').format(_selectedDate);
    // //String orgName = widget.organizationName;
    // final String currentTime = DateFormat('HH:mm').format(DateTime.now());
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 20),
      child: ButtonTheme(
        child: CommonAppButton(
          onPressed: () async {
             WidgetsBinding.instance
            .addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                           StockViewPage(
                            organizationName2: organizationName,
                            organizationNummer2 :organizationNummer,
                           )),
                  (Route<dynamic> route) => false,
                ));

          },
          buttonText: "View Stock",
        ),
     ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the loading dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: CustomColors.abasColor,
          ), // Loading indicator
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      // Close the loading dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Location Error"),
            content: const Text(
              "Please enable location services to mark your visit!",
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
}
