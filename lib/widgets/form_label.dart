import 'package:flutter/material.dart';
import 'package:sdm_mobile/utils/constants.dart';

class FormLabel extends StatelessWidget {
  final String? text;

  const FormLabel({super.key, @required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.0,
      child: Text(
        text.toString(),
        style: const TextStyle(fontSize: 16.0, color: CustomColors.textColor),
      ),
    );
  }
}
