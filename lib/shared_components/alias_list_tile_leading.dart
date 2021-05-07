import 'package:flutter/material.dart';

class AliasListTileLeading extends StatelessWidget {
  AliasListTileLeading(
      {Key key, @required this.isDeleted, @required this.isActive})
      : super(key: key);

  final bool isDeleted, isActive;

  final activeGradient = [Color(0xff31b237), Colors.white];
  final deletedGradient = [Colors.grey, Colors.white];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: RadialGradient(
          radius: 0.7,
          stops: [0.15, 1.0],
          colors: isDeleted
              ? deletedGradient
              : isActive
                  ? activeGradient
                  : deletedGradient,
        ),
      ),
    );
  }
}
