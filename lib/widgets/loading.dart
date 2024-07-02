import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

class Loading extends StatelessWidget {
  final String? loadingMessage;
  const Loading({key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
    
          SizedBox(height: 24),
          CircularProgressIndicator(
           valueColor: AlwaysStoppedAnimation<Color>(CustomColors.appBarColor),
         ),
        ],
      ),
    );
  }
}
