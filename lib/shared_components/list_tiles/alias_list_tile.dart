import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../custom_page_route.dart';
import 'alias_list_tile_leading.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({Key key, this.aliasData}) : super(key: key);
  final AliasDataModel aliasData;

  @override
  Widget build(BuildContext context) {
    final copyOnTap = NicheMethod().copyOnTap;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aliasDataProvider = context.read(aliasStateManagerProvider);

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
              isActive: aliasData.isAliasActive,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${aliasData.email}',
                    style: TextStyle(
                      color: isAliasDeleted()
                          ? Colors.grey
                          : isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  Text(
                    '${aliasData.emailDescription}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed:
                  isAliasDeleted() ? null : () => copyOnTap(aliasData.email),
            ),
          ],
        ),
      ),
      onTap: () {
        aliasDataProvider.aliasDataModel = aliasData;
        Navigator.push(context, CustomPageRoute(AliasDetailScreen()));
      },
    );
  }
}
