import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

showConfirmationDialog(BuildContext context, String itemCode, VoidCallback callback) {
  Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: CustomColors.buttonColor)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(false);
        });
      });
  Widget deleteButton = TextButton(
      onPressed: callback,
      child: const Text("Delete", style: TextStyle(color: CustomColors.buttonColor)));
  AlertDialog alert = AlertDialog(
    title: const Text("Delete"),
    content: Text('Are you sure you want to delete this item: $itemCode?'),
    actions: [cancelButton, deleteButton],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
