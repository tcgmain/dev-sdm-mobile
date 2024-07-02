import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

class HomeButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;
  final double minWidth;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const HomeButton({super.key, 
    required this.buttonText,
    required this.onPressed,
    this.minWidth = 600.0,
    this.height =120,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  Widget _buildButton() {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          side: const BorderSide(
            color: Color.fromARGB(24, 3, 238, 179), // Set your border color here
            width: 0.1, // Use the border side width property
          ),
         elevation: 5,
          shadowColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.0),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:   [
                const Color.fromARGB(162, 1, 107, 93).withOpacity(0.3),
                const Color.fromARGB(137, 0, 250, 221).withOpacity(0.3),
                const Color.fromARGB(143, 0, 150, 250).withOpacity(0.3),
                const Color.fromARGB(158, 3, 19, 236).withOpacity(0.3),
        ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              color: const Color.fromRGBO(146, 250, 245, 1),
              fontSize: getFontSizeall(20.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }
}
