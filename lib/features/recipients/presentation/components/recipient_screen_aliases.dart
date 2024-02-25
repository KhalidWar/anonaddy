import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientScreenAliases extends ConsumerWidget {
  const RecipientScreenAliases({
    Key? key,
    required this.recipientId,
  }) : super(key: key);

  final String recipientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final recipientScreenAsync =
        ref.watch(recipientScreenNotifierProvider(recipientId));

    return recipientScreenAsync.when(
      data: (recipientScreenState) {
        final aliases = recipientScreenState.recipient.aliases;

        if (aliases == null || aliases.isEmpty) {
          return const SizedBox.shrink();
        }

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
            if (aliases.isEmpty)
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  child: const Text('No aliases found'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: aliases.length,
                itemBuilder: (context, index) {
                  return AliasListTile(
                    alias: aliases[index],
                  );
                },
              ),
          ],
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
