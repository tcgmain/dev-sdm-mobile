import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

class CommonAppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CommonAppButton({super.key, 
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(
            color: Colors.white.withOpacity(0.6),
            width: 1,
          ),
          elevation: 10,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(162, 1, 107, 93).withOpacity(0.3),
                const Color.fromARGB(137, 0, 250, 221).withOpacity(0.3),
                const Color.fromARGB(143, 0, 150, 250).withOpacity(0.3),
                const Color.fromARGB(158, 3, 19, 236).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: getFontSize(),
            ),
          ),
        ),
      ),
    );
  }
}
