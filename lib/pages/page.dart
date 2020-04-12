import 'package:flutter/material.dart';

Route animateRoute({page, context}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-10, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          transformHitTests: true,
          position: animation.drive(tween),
          child: child,
        );
      },
      barrierDismissible: true);
}
