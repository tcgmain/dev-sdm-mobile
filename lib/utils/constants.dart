// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomColors {
  static const Color abasColor =  Color(0xFF20bca4);
  static const Color appBarColor = Color(0xFF20bca4);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color formBackgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF84898D);
  static const Color textFieldFillColor = Color(0xFFFFFFFF);
  static const Color buttonColor = Color(0xFFF2C6FBB);
  static const Color buttonTextColor = Color.fromARGB(188, 71, 71, 71);
}

class CustomBorderSide {
  static BorderSide buttonBorderSide({
    Color color = CustomColors.abasColor, // Default color
    double width = 1.0, // Default width
  }) {
    return BorderSide(
      color: color,
      width: width,
    );
  }
}

getFontSize() {
  var textSize = 16.0;
  return textSize;
}

getFontSizeSmall() {
  var textSize = 14.0;
  return textSize;
}

getFontSizeLarge() {
  var headerTextSize = 20.0;
  return headerTextSize;
}

getFontSizeall(double size) {
  var commanTextSize = size;
  return commanTextSize;
}

getFontSizeExtraLarge() {
  var textSize = 22.0;
  return textSize;
}

getAppBarTextSize() {
  var textSize = 20.0;
  return textSize;
}

getDateFormat(date) {
  var formattedDate = DateFormat('yyyy/MM/dd').format(date);
  return formattedDate;
}

getHorizontalTitleGap() {
  double horizontalTitleGap = 5.0;
  return horizontalTitleGap;
}

Future<String> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username') ?? 'default_username';
  return username;
}

Future<String> getUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = prefs.getString('userID') ?? 'default_userId';
  return userID;
}