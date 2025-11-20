import 'package:flutter/material.dart';

class Uihelper {
  static customInfoshow(double hieght, double width, String text) {
    return SizedBox(

    height: hieght,
    width: width,

    child: Text(text,
    style: TextStyle(fontWeight: FontWeight.bold, 
    fontSize: 20),),
    
  

    );
  }
}
