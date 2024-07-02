import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/organization_list_view.dart';
import 'package:sdm_mobile/view/stock_update_view.dart';
import 'package:sdm_mobile/view/view_stock.dart';
import 'package:sdm_mobile/widgets/appbar.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/home_buttons.dart';

// ignore: library_prefixes
class MarkVisitHome extends StatefulWidget {
  final String organizationName;
  final String organizationNummer;
  const MarkVisitHome({
    Key? key,
    required this.organizationName,
    required this.organizationNummer,
    }):super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MarkVisitHomeState createState() => _MarkVisitHomeState();
}

class _MarkVisitHomeState extends State<MarkVisitHome> {
  @override
  void initState() {
    super.initState();

  }
  Widget stockUpdate(BuildContext context) {
    return HomeButton(
      buttonText: "Goods Update",
      onPressed: () async {
          String organizationName1 =widget.organizationName;
          String organizationNummer1 = widget.organizationNummer;
          print("///////////////////////////////////////$organizationNummer1");
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StockupdatePage(
          organizationName2: organizationName1,
          organizationNummer2 :organizationNummer1
          )),
          (Route<dynamic> route) => false,
          ));

      },
    );
  }

  Widget viewStock(BuildContext context) {
    String organizationName1 =widget.organizationName;
    String organizationNummer1 = widget.organizationNummer;
    return HomeButton(
      buttonText: "View Stock",
      onPressed: () async {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                           StockViewPage(
                            organizationName2: organizationName1,
                            organizationNummer2 :organizationNummer1
                           )),
                  (Route<dynamic> route) => false,
                ));

        print("2");
      },
    );
  }

  Widget createSO(BuildContext context) {
    return HomeButton(
      buttonText: "Create SO",
          onPressed: () async {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                             const OrganizationList()),
                      (Route<dynamic> route) => false,
                    ));

            print("3");
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
                          color: Colors.white.withOpacity(0.2),
                          width : 1.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric( horizontal: 10, vertical: 35),
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
                                    stockUpdate(context),
                                    const SizedBox(height: 20.0),
                                    viewStock(context),
                                    const SizedBox(height: 20.0),
                                    createSO(context),
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
            child: CommonAppBar(
              title: 'Visit: ${widget.organizationName}',
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
