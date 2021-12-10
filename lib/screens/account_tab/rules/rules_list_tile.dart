import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile_leading.dart';
import 'package:flutter/material.dart';

class RulesListTile extends StatelessWidget {
  const RulesListTile({
    Key? key,
    required this.rule,
    required this.onTap,
  }) : super(key: key);

  final Rules rule;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AliasListTileLeading(
              isActive: rule.active,
              isDeleted: false,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rule.name),
                SizedBox(height: 2),
                Text(
                  'order ' + rule.order.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
