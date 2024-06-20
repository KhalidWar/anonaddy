import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDefaultRecipientScreen extends ConsumerWidget {
  const AliasDefaultRecipientScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultRecipientAsync =
        ref.watch(defaultRecipientNotifierProvider(id));

    return defaultRecipientAsync.when(
      data: (defaultRecipientState) {
        final verifiedRecipients = defaultRecipientState.verifiedRecipients;

        return verifiedRecipients.isEmpty
            ? Container(
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No recipients found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: verifiedRecipients.length,
                itemBuilder: (context, index) {
                  final verifiedRecipient = verifiedRecipients[index];
                  final isSelected = defaultRecipientState.defaultRecipients
                      .map((recipient) => recipient.id)
                      .contains(verifiedRecipient.id);

                  return RecipientListTile(
                    recipient: verifiedRecipient,
                    isSelected: isSelected,
                    onPress: () {
                      ref
                          .read(defaultRecipientNotifierProvider(id).notifier)
                          .toggleRecipient(verifiedRecipient);
                    },
                  );
                },
              );
      },
      error: (error, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: ErrorMessageWidget(message: error.toString()),
        );
      },
      loading: () => SizedBox(
        height: MediaQuery.of(context).size.height * .2,
        width: double.infinity,
        child: const Center(
          child: PlatformLoadingIndicator(),
        ),
      ),
    );
  }
}
