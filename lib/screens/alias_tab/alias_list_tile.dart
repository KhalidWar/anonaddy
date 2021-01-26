import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/widgets/alias_list_tile_leading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasListTile extends ConsumerWidget {
  const AliasListTile({Key key, this.aliasData}) : super(key: key);
  final AliasDataModel aliasData;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasState = watch(aliasStateManagerProvider);
    final copyAlias = aliasState.copyToClipboard;
    final isDeleted = aliasState.isAliasDeleted;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.only(left: 6),
      dense: true,
      horizontalTitleGap: 0,
      // minLeadingWidth: 0,
      title: Text(
        '${aliasData.email}',
        style: TextStyle(
          color: isDeleted(aliasData.deletedAt)
              ? Colors.grey
              : isDark
                  ? Colors.white
                  : Colors.black,
        ),
      ),
      subtitle: Text(
        '${aliasData.emailDescription}',
        style: TextStyle(color: Colors.grey),
      ),
      leading: AliasListTileLeading(
        isDeleted: isDeleted(aliasData.deletedAt),
        aliasData: aliasData,
      ),
      trailing: IconButton(
        icon: Icon(Icons.copy),
        onPressed: isDeleted(aliasData.deletedAt)
            ? null
            : () => copyAlias(aliasData.email),
      ),
    );
  }
}
