import 'package:anonaddy/features/rules/domain/rules.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile_leading.dart';
import 'package:flutter/material.dart';

class RulesListTile extends StatelessWidget {
  const RulesListTile({
    super.key,
    required this.rule,
    required this.onTap,
  });

  final Rules rule;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AliasListTileLeading(
              isActive: rule.active,
              isDeleted: false,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rule.name),
                Text(
                  'order ${rule.order}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
