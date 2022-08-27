import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientScreenAliases extends ConsumerWidget {
  const RecipientScreenAliases({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final recipientScreenState = ref.watch(recipientScreenStateNotifier);
    final recipient = recipientScreenState.recipient;

    if (recipientScreenState.recipient.aliases.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
            child:
                Text('Aliases', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: size.height * 0.01),
          if (recipient.aliases.isEmpty)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                child: const Text('No aliases found'))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipient.aliases.length,
              itemBuilder: (context, index) {
                return AliasListTile(
                  alias: recipient.aliases[index],
                );
              },
            ),
        ],
      );
    }

    return Container();
  }
}
