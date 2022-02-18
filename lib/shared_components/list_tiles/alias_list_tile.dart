import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile_leading.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({Key? key, required this.aliasData}) : super(key: key);
  final Alias aliasData;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool isAliasDeleted() {
      return aliasData.deletedAt == null ? false : true;
    }

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          children: [
            AliasListTileLeading(
              isDeleted: isAliasDeleted(),
              isActive: aliasData.active,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aliasData.email,
                    style: TextStyle(
                      color: isAliasDeleted()
                          ? Colors.grey
                          : isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  Text(
                    aliasData.description ?? 'No description',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: isAliasDeleted()
                  ? null
                  : () => NicheMethod.copyOnTap(aliasData.email),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AliasScreen.routeName,
          arguments: aliasData,
        );
      },
    );
  }
}
