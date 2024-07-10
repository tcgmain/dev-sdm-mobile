import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/organization_list_view.dart';
import 'package:sdm_mobile/view/add_organization_view.dart';
import 'package:sdm_mobile/view/my_route_view.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/home_app_bar.dart';
import 'package:sdm_mobile/widgets/home_buttons.dart';

// ignore: library_prefixes
class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  @override
  void initState() {
    super.initState();
  }

  Widget homeButton1(BuildContext context) {
    return HomeButton(
      buttonText: "My Route",
      onPressed: () async {
         Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MyRoutePage()));
      },
    );
  }

  Widget homeButton2(BuildContext context) {
    return HomeButton(
      buttonText: "My Region",
      onPressed: () async {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrganizationList()));
      },
    );
  }

  Widget homeButton3(BuildContext context) {
    return HomeButton(
      buttonText: "Add Organizations",
      onPressed: () async {
         Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddOrganizationPage()));
      },
    );
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
                height: contWidth * 1.6,
                border: Border.all(
                    color: Colors.white.withOpacity(0.2), width: 1.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(height: 20.0),
                                    homeButton1(context),
                                    const SizedBox(height: 20.0),
                                    homeButton2(context),
                                    const SizedBox(height: 20.0),
                                    homeButton3(context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CommonAppBarHome(
              title: 'Home',
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
}
