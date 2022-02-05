import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    Key? key,
    required this.showFab,
    required this.child,
  }) : super(key: key);
  final bool showFab;
  final Widget child;

  @override
  _AnimatedFabState createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  /// Manages which direction the animation should go
  /// depending on whether FAB is becoming visible or not.
  void animate() {
    log('animate is called');
    if (_animationController.isAnimating) return;
    if (widget.showFab) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// As far as I can tell, it's safe to call this method inside [build]
    /// because it doesn't trigger a rebuild or a re-animation.
    /// It only changes the direction of the animation controller.
    animate();

    /// [AnimatedBuilder] is responsible for animating the child widget
    /// according to [controller] values.
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        log('AnimatedBuilder is called');

        return Transform.scale(
          scale: _animationController.value,
          child: Transform.rotate(
            angle: math.pi * _animationController.value,
            child: child,
          ),
        );
      },
    );
  }
}
