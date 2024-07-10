import 'package:flutter/material.dart';
import 'package:sdm_mobile/blocs/route_organization_bloc.dart';
import 'package:sdm_mobile/models/route_organization.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/view/my_route_view.dart';
import 'package:sdm_mobile/view/organization_home_view.dart';
import 'package:sdm_mobile/widgets/appbar.dart';
import 'package:sdm_mobile/widgets/error_alert.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/loading.dart';

class OrganizationPage extends StatefulWidget {
  final String routeName;
  final String routeNumber;
  const OrganizationPage({Key? key, 
                      required this.routeName,
                      required this.routeNumber,
                      })
      : super(key: key);

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  late RouteOrganizationBloc _routeOrganizationBloc;
  late String routeNew ;
  late String routeNumberNew ;

  @override
  void initState() {
    super.initState();
    _routeOrganizationBloc = RouteOrganizationBloc();
    routeNew = widget.routeName;
    routeNumberNew=widget.routeNumber;
    _getRouteOrganizationList();
  }

  @override
  void dispose() {
    _routeOrganizationBloc.dispose();
    super.dispose();
  }

  void _getRouteOrganizationList() {
    _routeOrganizationBloc.getRouteOrganization();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100),
              child: FrostedGlassBox(
                width: contWidth,
                height: contWidth * 1.7,
                border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width : 1.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                        Expanded(
                          child: StreamBuilder<ResponseList<RouteOrganization>>(
                            stream: _routeOrganizationBloc.routeOrganizationStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                switch (snapshot.data!.status!) {
                                  case Status.LOADING:
                                    return Loading(loadingMessage: snapshot.data!.message.toString());

                                  case Status.COMPLETED:
                                    return ListView.builder(
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder: (context, index) {
                                        final organization = snapshot.data!.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color.fromARGB(255, 243, 180, 6).withOpacity(0.13),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 0),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                              backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              side: BorderSide(
                                                color: const Color.fromARGB(255, 243, 180, 6).withOpacity(0.8),
                                                width: 0.2,
                                              ),
                                              elevation: 10,
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () async {
                                              print(organization.nummer);
                                              print("********************************${organization.latitude}");
                                              print(organization.ysdmorg);

                                              Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>  OraganizationHomePage1(
                                                              routeName : routeNew.toString(),
                                                              routeNumber : routeNumberNew.toString(),
                                                              organizationNummer: organization.orgnummer.toString(),
                                                              organizationPhone1: organization.yphone1.toString(),
                                                              organizationPhone2: organization.yphone2.toString(),
                                                              organizationAddress1: organization.yaddressl1.toString(),
                                                              organizationAddress2: organization.yaddressl2.toString(),
                                                              organizationAddress3: organization.yaddressl3.toString(),
                                                              organizationAddress4: organization.yaddressl4.toString(),
                                                              organizationColour: organization.colour.toString(),
                                                              organizationLongitude: organization.longitude.toString(),
                                                              organizationLatitude: organization.latitude.toString(),
                                                              organizationDistance: organization.distance.toString(),
                                                              organizationName: organization.namebspr.toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                            child: Text(organization.ysdmorg.toString()),
                                            ),
                                          )
                                       );
                                    },
                                 );
                                  case Status.ERROR:
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          showErrorAlertDialog(context, snapshot.data!.message.toString());
                                              });
                                                break;
                                          }
                                      }
                                          return const Center(
                                            child: Text('No Data Available'),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CommonAppBar(
                title: 'My Organization',
                onBackButtonPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyRoutePage()),
                        (Route<dynamic> route) => false,
                      ));
                },
                userName: '', // Update this with the actual username if necessary
              ),
            ),
          ],
        ),
      ),
    );
  }
}
