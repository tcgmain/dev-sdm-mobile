import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdm_mobile/blocs/my_route_bloc.dart';
import 'package:sdm_mobile/models/my_route.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/view/home_view.dart';
import 'package:sdm_mobile/view/home_view1.dart';
import 'package:sdm_mobile/view/route_organization_view.dart';
import 'package:sdm_mobile/widgets/App_Button.dart';
import 'package:sdm_mobile/widgets/appbar.dart';
import 'package:sdm_mobile/widgets/date_picker_calender.dart';
import 'package:sdm_mobile/widgets/error_alert.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRoutePage extends StatefulWidget {
  const MyRoutePage({super.key});

  @override
  State<MyRoutePage> createState() => _MyRoutePageState();
}

class _MyRoutePageState extends State<MyRoutePage> {
  late MyRouteBloc _myRouteBloc;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _myRouteBloc = MyRouteBloc();
    _getRoutesForSelectedDate();
  }

  @override
  void dispose() {
    _myRouteBloc.dispose();
    super.dispose();
  }

  void _getRoutesForSelectedDate() {
    // Format the date to a string if necessary
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _myRouteBloc
        .getMyRoute(formattedDate); // Pass the selected date to the bloc
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
        _getRoutesForSelectedDate(); // Fetch routes for the new selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          title: 'My Routes',
          onBackButtonPressed: () {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false,
                    ));
          },
          userName: '',
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getRoutesForSelectedDate();
          },
          child: const Icon(Icons.refresh),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            CommonAppButton(
                              buttonText: 'Select Date',
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<ResponseList<MyRoute>>(
                          stream: _myRouteBloc.myRouteStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status!) {
                                case Status.LOADING:
                                  return Loading(
                                      loadingMessage:
                                          snapshot.data!.message.toString());

                                case Status.COMPLETED:
                                  return ListView.builder(
                                    itemCount: snapshot.data!.data!.length,
                                    itemBuilder: (context, index) {
                                      final route = snapshot.data!.data![index];
                                      final routeNumb =
                                          route.yplrouteNummer?.toString() ??
                                              'Unnamed Route';
                                      final routeName =
                                          route.yplrouteNamebspr?.toString() ??
                                              'Unnamed Route';
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.transparent,
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            side: BorderSide(
                                              color: const Color.fromARGB(
                                                      255, 243, 180, 6)
                                                  .withOpacity(0.8),
                                              width: 0.5,
                                            ),
                                            elevation: 10,
                                            shadowColor: const Color.fromARGB(
                                                    255, 243, 180, 6)
                                                .withOpacity(0.13),
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () async {
                                            print(route.yplrouteNamebspr);
                                            print(route.sdmem);
                                            print(route.id);
                                            print(route.ypldate);
                                            print(route.yplrouteNummer);

                                            // Saving route number in local storage
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setString(
                                              'yplroute^nummer',
                                              route.yplrouteNummer.toString(),
                                            );
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrganizationPage(
                                                        routeName: routeName,
                                                        routeNumber: routeNumb,
                                                      )),
                                            );
                                          },
                                          child: IntrinsicHeight(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              child: Text(
                                                route.yplrouteNamebspr
                                                    .toString(),
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      .withOpacity(0.8),
                                                  fontSize: 16.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                case Status.ERROR:
                                  if (snapshot.data!.message.toString() ==
                                      "404") {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      showErrorAlertDialog(context,
                                          "No routes haven't been assigned yet.");
                                    });
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      showErrorAlertDialog(context,
                                          snapshot.data!.message.toString());
                                    });
                                  }
                              }
                            }
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
