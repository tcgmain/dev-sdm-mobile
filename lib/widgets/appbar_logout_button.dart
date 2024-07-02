import 'package:sdm_mobile/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showLogoutConfirmationDialog(context);
      },
      style: const ButtonStyle(
       // foregroundColor: WidgetStateProperty.all(Colors.white),
       // backgroundColor: WidgetStateProperty.all(CustomColors.appBarColor),
      ),
      child: const Icon(Icons.logout),
    );
  }
}

showLogoutConfirmationDialog(BuildContext context) {
  Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: CustomColors.buttonColor)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(false);
        });
      });

  Widget yesButton = TextButton(
      child: const Text('Yes', style: TextStyle(color: CustomColors.buttonColor)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            ));
      });

  AlertDialog alert = AlertDialog(
    content: const Text('Are you sure you want to log out?'),
    actions: [cancelButton, yesButton],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
