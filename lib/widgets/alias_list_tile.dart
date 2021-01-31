import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
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
    final aliasDataProvider = context.read(aliasStateManagerProvider);

    return ListTile(
      contentPadding: EdgeInsets.only(left: 6),
      dense: true,
      horizontalTitleGap: 0,
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
        isActive: aliasData.isAliasActive,
      ),
      trailing: IconButton(
        icon: Icon(Icons.copy),
        onPressed: isDeleted(aliasData.deletedAt)
            ? null
            : () => copyAlias(aliasData.email),
      ),
      onTap: () {
        aliasDataProvider.aliasDataModel = aliasData;
        aliasDataProvider.setSwitchValue(aliasData.isAliasActive);

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder: (context, animation, secondAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut);

              return SlideTransition(
                position: Tween(
                  begin: Offset(1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondAnimation) {
              return AliasDetailScreen();
            },
          ),
        );
      },
    );
  }
}
