import 'package:flutter/material.dart';
import 'package:sdm_mobile/view/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sales Data Management',
      theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(color: Color.fromRGBO(81, 95, 131, 1))
      ),
      home: const LoginPage(),
    );
  }
}
