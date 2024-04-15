import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_notifier.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDefaultRecipientScreen extends ConsumerStatefulWidget {
  const AliasDefaultRecipientScreen({
    super.key,
    required this.aliasId,
  });

  final String aliasId;

  @override
  ConsumerState createState() => _AliasDefaultRecipientScreenState();
}

class _AliasDefaultRecipientScreenState
    extends ConsumerState<AliasDefaultRecipientScreen> {
  @override
  void initState() {
    super.initState();

    /// After widgets are built, fetch recipients and display verified ones.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipientsNotifierProvider.notifier)
          .fetchRecipients(showLoading: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultRecipientAsync =
        ref.watch(defaultRecipientNotifierProvider(widget.aliasId));
    final defaultRecipientNotifier =
        ref.read(defaultRecipientNotifierProvider(widget.aliasId).notifier);

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

                  return RecipientListTile(
                    recipient: verifiedRecipient,
                    isSelected: defaultRecipientNotifier
                        .isRecipientDefault(verifiedRecipient),
                    onPress: () {
                      defaultRecipientNotifier
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
