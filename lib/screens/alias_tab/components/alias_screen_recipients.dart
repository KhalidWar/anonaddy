import 'package:anonaddy/notifiers/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/screens/alias_tab/alias_default_recipient.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasScreenRecipients extends ConsumerWidget {
  const AliasScreenRecipients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alias = ref.watch(aliasScreenStateNotifier).alias;

    return Column(
      children: [
        const Divider(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default Recipient${alias.recipients.length >= 2 ? 's' : ''}',
                key: AliasTabWidgetKeys.aliasScreenDefaultRecipient,
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
                      ),
                    ),
                    builder: (context) {
                      return AliasDefaultRecipientScreen(alias: alias);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        if (alias.recipients.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: const [
                Text(AppStrings.noDefaultRecipientSet),
              ],
            ),
          ),
        if (alias.recipients.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alias.recipients.length,
            itemBuilder: (context, index) {
              final recipients = alias.recipients;
              return RecipientListTile(recipient: recipients[index]);
            },
          ),
      ],
    );
  }
}
