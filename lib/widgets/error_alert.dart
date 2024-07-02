import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

showErrorAlertDialog(BuildContext context, errorMessage) {
  Widget okButton = TextButton(
      child: const Text("OK", style: TextStyle(color: CustomColors.buttonColor)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(false);
        });
      });
  AlertDialog alert = AlertDialog(
    title: const Text("Error!"),
    content: Text(errorMessage),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
