import 'package:flutter/material.dart';

Color mC = Colors.white;
Color mCL = Colors.grey[400];
Color mCD = Colors.black;
Color mCC = Colors.green.withOpacity(0.65);
Color fCD = Colors.grey.shade700;
Color fCL = Colors.grey;

BoxDecoration nMbox = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: mC,
  boxShadow: [
    BoxShadow(
      color: mCD,
      offset: Offset(1, 1),
      blurRadius: 1,

    ),
    BoxShadow(
      color: mCL,
      offset: Offset(-1, -0),
      blurRadius: 1,
      spreadRadius: 1.0
    ),
  ]
);

BoxDecoration nMboxInvert = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: Colors.purple[200],
  boxShadow: [
    BoxShadow(
      color: mCL,
      offset: Offset(3, 3),
      blurRadius: 3,
      spreadRadius: -2
    ),
  ]
);

BoxDecoration nMboxInvertActive = nMboxInvert.copyWith(color: mCC);

BoxDecoration nMbtn = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: mC,
  boxShadow: [
    BoxShadow(
      color: mCD,
      offset: Offset(2, 2),
      blurRadius: 2,
    )
  ]
);