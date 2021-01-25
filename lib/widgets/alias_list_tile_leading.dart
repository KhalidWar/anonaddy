import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:flutter/material.dart';

class AliasListTileLeading extends StatelessWidget {
  const AliasListTileLeading(
      {Key key, @required this.isDeleted, @required this.aliasData})
      : super(key: key);

  final bool isDeleted;
  final AliasDataModel aliasData;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isDeleted
          ? Color(0xffe4e7eb)
          : aliasData.isAliasActive
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
              : aliasData.isAliasActive
                  ? Color(0xff31b237)
                  : Colors.grey,
        ),
      ),
    );
  }
}
