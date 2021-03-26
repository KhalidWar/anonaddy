import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute(this.child)
      : super(
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
          pageBuilder: (context, animation, secondAnimation) => child,
        );
}
