import 'dart:ui';

import 'package:flutter/material.dart';

final borderRadius = BorderRadius.circular(20.0);
class FrostedGlassBox extends StatelessWidget {
  final double width,height;
  final Widget child;
  final BoxBorder? border;

  const FrostedGlassBox({ Key ? key, 
  required this.width,
  required this.height,
  required this.border,
  required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius : borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            BackdropFilter(filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ), child : SizedBox(width: width, height: height, child : const Text(""), ),),
            Opacity(
            opacity : 0.05,
            child : Image.asset("images/noice.jpg", width: width, height: height,
            fit : BoxFit.cover,),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow : [
                  BoxShadow(
                    color: const Color.fromARGB(255, 5, 228, 191).withOpacity(0.0), 
                    blurRadius : 30,
                    spreadRadius: 5,
                    offset: const Offset(10, 10),)
                ],
                borderRadius: borderRadius,
                border : border,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(0, 255, 255, 255),
                    Color.fromARGB(28, 255, 255, 255)
                  ],
                  stops: [0.0, 1.0]
                ) ,
              ),
            ),
            Center(child: child), 
          ],
        ),
      ),
    );
  }
}