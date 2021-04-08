import 'package:flutter/material.dart';

class AliasListTileLeading extends StatelessWidget {
  const AliasListTileLeading(
      {Key key, @required this.isDeleted, @required this.isActive})
      : super(key: key);

  final bool isDeleted, isActive;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isDeleted
          ? Color(0xffe4e7eb)
          : isActive
              ? Color(0xffc1f2c7)
              : Color(0xffe4e7eb),
      radius: 14,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: isDeleted
              ? Colors.grey
              : isActive
                  ? Color(0xff31b237)
                  : Colors.grey,
        ),
      ),
    );
  }
}
