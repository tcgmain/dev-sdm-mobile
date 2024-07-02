// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  late final String labelText;
  late final TextEditingController controller;
  late final void Function(String?) onChanged;


  // Constants
  final Color fixedLabelColor = const Color.fromARGB(255, 253, 255, 255);
  final Color fixedCursorColor = const Color.fromARGB(255, 0, 0, 0);

 SearchTextField({ 
    required this. controller,
    required this.labelText,
    required this.onChanged,
  });

  @override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.white, // Border color
        width: 0.2, // Border width
      ),
      color: const Color.fromARGB(0, 255, 255, 255),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.0),
          blurRadius: 10,
          offset: const Offset(0,0), // Shadow position
        ),
      ],
    ),
    child: TextFormField(
      cursorColor: fixedCursorColor,
      decoration: InputDecoration(
        labelText: labelText,
        border: InputBorder.none,
        labelStyle: const TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 255, 255), // Transparent to hide default border
            width: 0.5,
          ),
        ),
      ),
      controller: controller,
      onChanged: onChanged,
    ),
  );
}


}
