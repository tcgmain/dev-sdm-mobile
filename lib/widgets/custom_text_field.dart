import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?) ? validator;
  final void Function(String?) onSaved;

  // Constants
  final Color fixedLabelColor = const Color.fromARGB(255, 253, 255, 255);
  final Color fixedCursorColor = const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7);

   CustomTextField({super.key, 
    required this.labelText,
    required this.controller,
    this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: fixedCursorColor,
        style: const TextStyle(color: Color.fromARGB(255, 255, 251, 5)),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 15,
            color: fixedLabelColor,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Set the line color when the field is not focused
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Set the line color when the field is focused
          ),
        ),
        controller: controller,
        validator: validator,
        onSaved: (value) {
          onSaved(value);
          }
    );
  }
}
