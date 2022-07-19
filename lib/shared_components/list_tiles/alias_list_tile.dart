import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile_leading.dart';
import 'package:anonaddy/utilities/niche_method.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    style: TextStyle(
                      color: isAliasDeleted()
                          ? Colors.grey
                          : isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  Text(
                    getDescription(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: isAliasDeleted()
                  ? null
                  : () => NicheMethod.copyOnTap(alias.email),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AliasScreen.routeName,
          arguments: alias,
        );
      },
    );
  }
}
