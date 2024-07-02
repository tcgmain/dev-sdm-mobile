import 'dart:ui';

import 'package:flutter/material.dart';

final borderRadius = BorderRadius.circular(20.0);
class FrostedGlassBoxForMessages extends StatelessWidget {
  final double width,height;
  final Widget child;

  const FrostedGlassBoxForMessages({ Key ? key, 
  required this.width,
  required this.height,
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
              sigmaX: 0.5,
              sigmaY: 0.5,
            ), child : SizedBox(width: width, height: height, child : const Text(""), ),),
            Opacity(
            opacity : 0.15,
            child : Image.asset("images/noice.jpg", width: width, height: height,
            fit : BoxFit.cover,),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow : [
                  BoxShadow(
                    color: const Color.fromARGB(43, 97, 188, 248).withOpacity(0.2), 
                    blurRadius : 50,
                    spreadRadius: 0,
                    offset: const Offset(10, 10),)
                ],
                borderRadius: borderRadius,
                border : Border.all(color: Colors.white.withOpacity(0.2), width : 1.0),
                gradient:  LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(123, 0, 0, 0).withOpacity(0.8),
                    const Color.fromARGB(103, 2, 110, 182).withOpacity(0.2),
                  ],
                  stops: const [0.0, 1.0]
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