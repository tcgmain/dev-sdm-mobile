import 'package:flutter/material.dart';
import 'package:sdm_mobile/blocs/mark_visit_bloc.dart';
// ignore: library_prefixes
import 'package:sdm_mobile/models/mark_visit.dart' as markVisitModels;
import 'package:sdm_mobile/repository/mark_visit_repository.dart';
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/home_view1.dart';
import 'package:sdm_mobile/view/organization_home_view.dart';
import 'package:sdm_mobile/widgets/appbar.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/search_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizationList extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const OrganizationList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrganizationListPageState createState() => _OrganizationListPageState();
}

class _OrganizationListPageState extends State<OrganizationList> {
  List<markVisitModels.Organization> organizations = [];
  List<markVisitModels.Organization> displayedOrganizations = [];
  markVisitModels.Organization markvisitModel = markVisitModels.Organization();
  String? selectedOrganization = "select Organization";
  String finalTextToBeDisplayed = "";
  bool isDataLoaded = false;
  final MarkVisitRepository _markVisitRepo = MarkVisitRepository();
  String userName = "";
  late MarkVisitBloc _markVisitBloc;
  late String routeNew = '';
  late String routeNumber = "";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  int itemsToLoad = 10;
  bool isloadingMore = false;

  @override
  void initState() {
    super.initState();
    selectedOrganization = null;
    _markVisitBloc = MarkVisitBloc();
    _scrollController.addListener(_scrollListener);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _initializeUsername();
    await _fetchOrganizations();
    _loadMoreItems(); // Ensure this is also asynchronous if it involves async operations
    _markVisitBloc.visits(userName);
  }

  Future<void> _initializeUsername() async {
    userName = await getUsername();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void dispose() {
    _markVisitBloc.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrganizations() async {
    organizations = await _markVisitRepo.getOrganization(userName);
    organizations.sort((a, b) => a.namebspr!.compareTo(b.namebspr!));
  }

  void _loadMoreItems() {
    setState(() {
      isloadingMore = true;
      final int remainingItems = organizations.length - displayedOrganizations.length;
      final int itemsToAdd = remainingItems >= itemsToLoad ? itemsToLoad : remainingItems;
      displayedOrganizations.addAll(organizations.getRange(
          displayedOrganizations.length, displayedOrganizations.length + itemsToAdd));
      isloadingMore = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  List<markVisitModels.Organization> _getFilteredOrganizations() {
    if (_searchQuery.isEmpty) {
      return displayedOrganizations;
    } else {
      return organizations
          .where((org) => org.namebspr!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;

    List<markVisitModels.Organization> filteredOrganizations = _getFilteredOrganizations();

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
            ListView(
              children: [
                const SizedBox(height: 20,),
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SearchTextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value!.toLowerCase();
                                });
                              },
                              labelText: '    Search Organization',
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: Stack(
                              children: [
                                ListView.builder(
                                  controller: _scrollController,
                                  itemCount: filteredOrganizations.length,
                                  itemBuilder: (context, index) {
                                    final organization = filteredOrganizations[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.13),
                                              blurRadius: 5,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: const Color.fromARGB(68, 255, 255, 255),
                                            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            side: const BorderSide(
                                              color:  Color.fromARGB(106, 255, 255, 255),
                                              width: 0.2,
                                            ),
                                            elevation: 10,
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('yplroute^nummer', organization.namebspr.toString());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OraganizationHomePage1(
                                                  routeName: '',
                                                  routeNumber: '',
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
                                          child: IntrinsicHeight(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              child: Text(
                                                organization.namebspr.toString(),
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                                                  fontSize: 16.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (isloadingMore)
                                  const Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: CircularProgressIndicator(),
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
              ],
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
                        MaterialPageRoute(builder: (context) => const HomePage1()),
                        (Route<dynamic> route) => false,
                      ));
                },
                userName: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
