import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdm_mobile/blocs/get_good_management_id_bloc.dart';
import 'package:sdm_mobile/blocs/goods_update_bloc.dart';
import 'package:sdm_mobile/blocs/update_stock_block.dart';
import 'package:sdm_mobile/models/get_good_management_id.dart';
//import 'package:sdm_mobile/models/goods_update.dart';
import 'package:sdm_mobile/models/update_stock.dart';
import 'package:sdm_mobile/networking/response.dart';
import 'package:sdm_mobile/repository/update_stock_repository.dart';
import 'package:sdm_mobile/utils/constants.dart';
import 'package:sdm_mobile/view/mark_visit_home.dart';
import 'package:sdm_mobile/widgets/App_Button.dart';
import 'package:sdm_mobile/widgets/appbar.dart';
import 'package:sdm_mobile/widgets/date_picker_calender.dart';
import 'package:sdm_mobile/widgets/error_alert.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box.dart';
import 'package:sdm_mobile/widgets/frotest_glass_box_message.dart';
import 'package:sdm_mobile/widgets/loading.dart';
import 'package:sdm_mobile/widgets/search_field.dart';

class StockupdatePage extends StatefulWidget {
  final String organizationName2;
  final String organizationNummer2;
  const StockupdatePage({
    Key? key,
    required this.organizationName2,
    required this.organizationNummer2,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StockupdatePageState createState() => _StockupdatePageState();
}

class _StockupdatePageState extends State<StockupdatePage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController stockController = TextEditingController();
  // List<String> product = [];
  List<ProductItem> productItems = [];
  late UpdateStockBloc _updateStockBloc;
  final UpdateStockRepository _updateStockRepo = UpdateStockRepository();
  bool isDataLoaded = false;
  String userName = "Ashen_IT";
  String organizationName3 = "";
  String organizationNummer3 = '';
  String organizationId = "";
  String orgId = '';
  String? productNummer;
  String? productDescription;
  late GetGoodMangementIdBloc _getGoodMangIdBloc;
  late GoodsUpdateBloc _goodsUpdateBloc;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String productName = '';
  // ignore: non_constant_identifier_names

  @override
  void initState() {
    super.initState();
    _updateStockBloc = UpdateStockBloc();
    _getGoodMangIdBloc = GetGoodMangementIdBloc();
    _goodsUpdateBloc = GoodsUpdateBloc();
    organizationNummer3 = widget.organizationNummer2;
    organizationName3 = widget.organizationName2;
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await getProduct();
      _updateStockBloc.product(userName, organizationNummer3);
      _getGoodMangIdBloc.getID(organizationNummer3);
    } catch (e) {
      print("Initialization Error: $e");
    }
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


  Future<void> getProduct() async {
    try {
      ProductData productData =
          await _updateStockRepo.getProduct(userName, organizationNummer3);
      setState(() {
        productItems = productData.table
            .map((e) => ProductItem(headerValue: e.yproddesc))
            .toList();
        //product.insert(0, "Select Organization");
        isDataLoaded = true;
      });
    } catch (e) {
      print("Product Load ERROR: $e");
    }
  }
  Widget organizationID() {
    return StreamBuilder<ResponseList<GetGoodManagementID>>(
      stream: _getGoodMangIdBloc.getGoodManagementIdStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              print("loading");

            case Status.COMPLETED:
                var dataList = snapshot.data!.data!;
                if (dataList.isNotEmpty) {
                  var firstItem = dataList[0];
                  organizationId = firstItem.id.toString();
                  // You can display or use the ID as needed
                  print("*************************************$organizationId");
                } else {
                  print('No data available');
                }
            case Status.ERROR:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
                return Container(); // Ensure you return a container or relevant widget here
          }
        }
        return Container();
      },
    );
  }


  Future<void> stockUpdateDialog(String productName, DateTime date, String? pronummer) async {
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
          height: contWidth ,
          // color: Color.fromARGB(84, 230, 189, 8),
          // borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Enter Stock for $productName",
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
                    controller: stockController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color.fromARGB(255, 255, 255, 255), // Set the cursor color here
                    decoration: const InputDecoration(
                      labelText: 'Stock Update',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255), // Change this to your desired color
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)), // Set the line color when the field is not focused
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 209, 162, 9)), // Set the line color when the field is focused
                      ),
                    ),
                    onChanged: (value) {
                      print("Stock Update Value: $value");
                    },
                  ),
                ),
            const SizedBox(height: 20),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                CommonAppButton(
                  buttonText: "Submit",
                  onPressed: () {
                    String inputValue = stockController.text;
                    if (inputValue.isEmpty) {
                      _showErrorDialog(context);
                    } else {
                      _goodsUpdateBloc.goodsUpdate(organizationId, date, pronummer!, inputValue, userName);
                      // _successDialog(context);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10,),
                 CommonAppButton(
                  buttonText: "Cancel",
                  onPressed: () => {
                    stockController.clear(),
                    Navigator.of(context).pop(),
                  },
                ),
              ],
            ),
          ],
        ),
                )
      );
    },
  );
}
    void _getRoutesForSelectedDate() {
    // Format the date to a string if necessary
    _updateStockBloc.product(userName, organizationNummer3);
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
         floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getRoutesForSelectedDate();
          },
          child: const Icon(Icons.refresh),
        ),
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
                title: 'Update Stock',
                 onBackButtonPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>MarkVisitHome(
                                      organizationNummer :organizationNummer3,
                                      organizationName : organizationName3,

                                    )),
                            (Route<dynamic> route) => false,
                          ));
                },
                userName: '',
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FrostedGlassBox(
                  width: contWidth,
                  height: contWidth * 1.65,
                  border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width : 1.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
                                    CommonAppButton(
                                      buttonText: 'Select Date',
                                      onPressed: () => _selectDate(context),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                  height: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: StreamBuilder<Response<ProductData>>(
                                      stream: _updateStockBloc.updateStockStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          switch (snapshot.data!.status!) {
                                            case Status.LOADING:
                                              return Loading(
                                                loadingMessage: snapshot.data!.message.toString(),
                                              );
                                            case Status.COMPLETED:
                                              var filteredProducts = snapshot
                                                  .data!.data!.table
                                                  .where((product) => product.yproddesc.toLowerCase().contains(_searchQuery.toLowerCase()))
                                                  .toList();
                                              filteredProducts.sort((a, b) => a.yproddesc.compareTo(b.yproddesc));
                                              var productItems = filteredProducts.map((e) {
                                                    productDescription = e.yproddesc;
                                                    productNummer = e.yprodnummer;
                                                    return ProductItem(headerValue: e.yproddesc);
                                              }).toList();
                                              return Column(
                                                children: [
                                                     const SizedBox(height: 10),
                                                       SearchTextField(
                                                            controller: _searchController,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _searchQuery = value!.toLowerCase();
                                                              });
                                                            },
                                                            labelText: '    Search Product',
                                                          ),
                                                        const SizedBox(height: 10,),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            itemCount: productItems.length,
                                                            itemBuilder: (context, index) {
                                                              var item = productItems[index];
                                                              if (_searchQuery.isNotEmpty && !item.headerValue.toLowerCase().contains(_searchQuery)) {
                                                                return const SizedBox.shrink();
                                                              }

                                                              return Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                                                                    foregroundColor: Colors.transparent,
                                                                    backgroundColor: Colors.transparent,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    side: BorderSide(
                                                                      color: Colors.white.withOpacity(0.6),
                                                                      width: 1,
                                                                    ),
                                                                    elevation: 10,
                                                                    shadowColor: Colors.transparent,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                  ),
                                                                  onPressed: () {
                                                                    stockUpdateDialog(item.headerValue, _selectedDate, productNummer);
                                                                    // print("*********************************$organizationNummer3");
                                                                  },
                                                                  child: Text(
                                                                    item.headerValue.toString(),
                                                                    style: TextStyle(
                                                                      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                                                                      fontSize: 16.0,
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                            },
                                                          ),
                                                        ),
                                                ],
                                              );
                                            case Status.ERROR:
                                              if (snapshot.data!.message.toString() == "404") {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  showErrorAlertDialog(context, "No Organization For This Employee.");
                                                });
                                              } else {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                                                });
                                              }
                                              return Container();
                                          }
                                        }
                                        return Container();
                                      },
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
            
            organizationID()
          ],
        ),
      ),
    );
  }
   void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent users from dismissing the loading dialog
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
            title: const Text("Goods Update Error"),
            content: const Text(
              "Please enter Stock for Submit!",
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

class ProductItem {
  ProductItem({
    required this.headerValue,
    this.isExpanded = false,
    this.stockDetails = '',
  });

  String headerValue;
  bool isExpanded;
  String stockDetails;
}
