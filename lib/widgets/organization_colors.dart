import 'package:flutter/material.dart';

class ColorPatch extends StatelessWidget {
  final String colorValue;

  const ColorPatch({super.key, required this.colorValue});

  @override
  Widget build(BuildContext context) {
    Color patchColor;
    switch (colorValue) {
      case 'RED':
        patchColor = Colors.red;
        break;
      case 'GREEN':
        patchColor = Colors.green;
        break;
      case 'ORANGE':
        patchColor = Colors.orange;
        break;
      case 'BLUE':
        patchColor = Colors.blue;
        break;  
      case 'YELLOW':
        patchColor = Colors.yellow;
        break;
      default:
        patchColor = Colors.grey; // Default color if the value is unknown
    }

    return Container(
      width: 20,
      height: 20,
      color: patchColor,
    );
  }
}
