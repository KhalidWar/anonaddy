import 'package:anonaddy/common/list_tiles/alias_list_tile_leading.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:flutter/material.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({
    super.key,
    required this.alias,
  });

  final Alias alias;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            AliasListTileLeading(
              isDeleted: alias.isDeleted,
              isActive: alias.active,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alias.email,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: alias.isDeleted
                              ? Colors.grey
                              : isDark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                  ),
                  Text(
                    alias.description.isEmpty
                        ? 'No description'
                        : alias.description,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: alias.isDeleted
                  ? null
                  : () => Utilities.copyOnTap(alias.email),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AliasScreen.routeName,
          arguments: alias.id,
        );
      },
    );
  }
}
