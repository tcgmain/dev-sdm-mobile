import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/validations.dart';

class TextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscureText;
  final String inputType; //Input Types = {none, email, password}
  final bool isRequired;
  // ignore: prefer_typing_uninitialized_variables
  final function;
  final VoidCallback onChangedFunction;
  // ignore: prefer_typing_uninitialized_variables
  final fillColor;
  final bool? filled;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? autoFocus;
  final Color? cursorErrorColor;

  const TextField(
      {super.key, required this.controller,
      this.obscureText,
      required this.inputType,
      required this.isRequired,
      this.function,
      required this.onChangedFunction,
      this.fillColor,
      this.filled,
      this.cursorErrorColor,
      this.labelText,
      this.suffixIcon,
      this.autoFocus});

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = FocusNode();
    return TextFormField(
      onChanged: (value) {
        onChangedFunction();
      },
      controller: controller,
      obscureText: obscureText!,
      cursorColor: cursorErrorColor,
      focusNode: myFocusNode,
      autofocus: autoFocus == true ? true : false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          filled: filled,
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: myFocusNode.hasFocus ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5) : Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          labelStyle: TextStyle(color: myFocusNode.hasFocus ? const Color.fromARGB(255, 1, 194, 253)  : const Color.fromARGB(255, 1, 194, 253) , fontWeight: FontWeight.bold)),

      // ignore: body_might_complete_normally_nullable
      validator: (v) {
        //Required
        if (isRequired == true) {
          if (inputType == 'none') {
            if (v!.isEmpty) {
              return "Required";
            } else {
              return null;
            }
          } else if (inputType == 'email') {
            if (v!.isEmpty) {
              return "Required";
            } else if (!v.isValidEmail) {
              return "Invalid";
            } else {
              return null;
            }
          } else if (inputType == 'password') {
            if (v!.isEmpty) {
              return "Required";
            } else if (!v.isValidPassword) {
              return "Invalid";
            } else {
              return null;
            }
          }
        }
        //Not required
        else {
          if (inputType == 'none') {
            return null;
          } else if (inputType == 'email') {
            if (v!.isValidEmail) {
              return "Invalid";
            } else {
              return null;
            }
          } else if (inputType == 'password') {
            if (v!.isValidPassword) {
              return "Invalid";
            } else {
              return null;
            }
          }
        }
      },
      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
    );
  }
}

Widget getPasswordSuffixIcon(function, obscureText) {
  return GestureDetector(
    onTap: function,
    child: obscureText
        ? const Icon(
            Icons.visibility,
            color:  Color.fromARGB(255, 18, 175, 167) 
          )
        : const Icon(Icons.visibility_off, color: Color.fromARGB(255, 255, 255, 255)),
  );
}
