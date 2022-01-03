import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

const MaterialColor kPrimaryColor = MaterialColor(
  0xFF0E7AC7,
  <int, Color>{
    50: Color(0xFF6200EE),
    100: Color(0xFF6200EE),

  },
);


const kSecondaryColor =  MaterialColor(
    0xFF0E7AC7,
    <int, Color>{
      50: Color(0xFFf5f7ec),
      100:Color(0xFFf5f7ec),

    }
);




const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);

TextStyle titleText =
TextStyle(color: kPrimaryColor, fontSize: 32, fontWeight: FontWeight.w700);
TextStyle subTitle = TextStyle(
    color: kSecondaryColor, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle textButton = TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);