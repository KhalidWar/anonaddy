import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile_leading.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({
    Key? key,
    required this.alias,
  }) : super(key: key);

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
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
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
                    style: Theme.of(context).textTheme.caption,
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
