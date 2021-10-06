import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';
import 'alias_list_tile_leading.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          children: [
            AliasListTileLeading(
              isDeleted: isAliasDeleted(),
              isActive: aliasData.active,
            ),
            SizedBox(width: 10),
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
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: isAliasDeleted()
                  ? null
                  : () => context.read(nicheMethods).copyOnTap(aliasData.email),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AliasDetailScreen.routeName,
          arguments: aliasData,
        );
      },
    );
  }
}
