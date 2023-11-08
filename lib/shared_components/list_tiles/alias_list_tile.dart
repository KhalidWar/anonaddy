import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile_leading.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({Key? key, required this.alias}) : super(key: key);
  final Alias alias;

  bool isAliasDeleted() {
    return alias.deletedAt.isEmpty ? false : true;
  }

  String getDescription() {
    return alias.description.isEmpty ? 'No description' : alias.description;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
        child: Row(
          children: [
            AliasListTileLeading(
              isDeleted: isAliasDeleted(),
              isActive: alias.active,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alias.email,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: isAliasDeleted()
                              ? Colors.grey
                              : isDark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                  ),
                  Text(
                    getDescription(),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: isAliasDeleted()
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
