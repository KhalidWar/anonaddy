import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/list_tiles/alias_list_tile_leading.dart';
import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/data/alias_screen_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/controller/available_aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/deleted_aliases_notifier.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasListTile extends ConsumerWidget {
  const AliasListTile({
    super.key,
    required this.alias,
    this.showDeleteRestore = false,
  });

  final Alias alias;
  final bool showDeleteRestore;

  Future<void> restoreAlias(WidgetRef ref) async {
    await ref
        .read(aliasScreenServiceProvider)
        .restoreAlias(alias.id)
        .whenComplete(ref
            .read(deletedAliasesNotifierProvider.notifier)
            .fetchDeletedAliases)
        .catchError((e) => Utilities.showToast(e.toString()));
  }

  Future<void> deletedAlias(WidgetRef ref) async {
    await ref
        .read(aliasScreenServiceProvider)
        .deleteAlias(alias.id)
        .whenComplete(
          ref.read(availableAliasesNotifierProvider.notifier).fetchAliases,
        )
        .catchError((e) => Utilities.showToast(e.toString()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: AliasListTileLeading(
        isDeleted: alias.isDeleted,
        isActive: alias.active,
      ),
      title: Text(alias.email),
      subtitle: Text(
        alias.description.isEmpty ? 'No description' : alias.description,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDeleteRestore)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon:
                  Icon(alias.isDeleted ? Icons.restore : Icons.delete_outline),
              onPressed: () async {
                PlatformAware.platformDialog(
                  context: context,
                  child: PlatformAlertDialog(
                    title: '${alias.isDeleted ? 'Restore' : 'Delete'} Alias',
                    content: alias.isDeleted
                        ? AddyString.restoreAliasConfirmation
                        : AddyString.deleteAliasConfirmation,
                    method: () async {
                      Navigator.pop(context);
                      alias.isDeleted
                          ? await restoreAlias(ref)
                          : await deletedAlias(ref);
                    },
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => Utilities.copyOnTap(alias.email),
          ),
        ],
      ),
      onTap: () {
        context.pushRoute(AliasScreenRoute(id: alias.id));
      },
    );
  }
}
