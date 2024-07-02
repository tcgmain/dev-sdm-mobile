// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DealerDropdownWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final List<String> dealers;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const DealerDropdownWidget({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.dealers,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  _DealerDropdownWidgetState createState() => _DealerDropdownWidgetState();
}

class _DealerDropdownWidgetState extends State<DealerDropdownWidget> {
  String? _selectedDealer;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedDealer,
      onChanged: (String? newValue) {
        setState(() {
          _selectedDealer = newValue;
        });
      },
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      items: widget.dealers.map<DropdownMenuItem<String>>((String dealer) {
        return DropdownMenuItem<String>(
          value: dealer,
          child: Text(dealer),
        );
      }).toList(),
    );
  }
}
