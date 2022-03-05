import 'package:flutter/material.dart';

class AliasListTileLeading extends StatelessWidget {
  const AliasListTileLeading({
    Key? key,
    required this.isDeleted,
    required this.isActive,
  }) : super(key: key);

  final bool isDeleted, isActive;

  final activeGradient = const [Color(0xff31b237), Colors.white];
  final deactivatedGradient = const [Colors.grey, Colors.white];
  final deletedGradient = const [Colors.red, Colors.white];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: RadialGradient(
          radius: 0.7,
          stops: const [0.15, 1.0],
          colors: isDeleted
              ? deletedGradient
              : isActive
                  ? activeGradient
                  : deactivatedGradient,
        ),
      ),
    );
  }
}
