import 'package:flutter/material.dart';

class CustomPageRoute {
  PageRouteBuilder customPageRouteBuilder(Widget child) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondAnimation, child) {
        animation = CurvedAnimation(
          parent: animation,
          curve: Curves.linearToEaseOut,
        );

        return SlideTransition(
          position: Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondAnimation) {
        return child;
      },
    );
  }
}
