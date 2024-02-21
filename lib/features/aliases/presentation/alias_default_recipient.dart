import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_notifier.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDefaultRecipientScreen extends ConsumerStatefulWidget {
  const AliasDefaultRecipientScreen({
    Key? key,
    required this.aliasId,
  }) : super(key: key);

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
        ref.watch(defaultRecipientStateNotifier(widget.aliasId));

    return defaultRecipientAsync.when(
      data: (defaultRecipientState) {
        final verifiedRecipients = defaultRecipientState.verifiedRecipients;
        final defaultRecipients = defaultRecipientState.defaultRecipients;

        return ListView(
          shrinkWrap: true,
          children: [
            if (verifiedRecipients.isEmpty)
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No recipients found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: verifiedRecipients.length,
                itemBuilder: (context, index) {
                  final verifiedRecipient = verifiedRecipients[index];
                  final bool isDefault = defaultRecipients
                      .map((recipient) => recipient.id)
                      .contains(verifiedRecipient.id);

                  return ListTile(
                    selected: isDefault,
                    selectedTileColor: AppColors.accentColor,
                    horizontalTitleGap: 0,
                    title: Text(
                      verifiedRecipient.email,
                      style: TextStyle(
                        color: isDefault
                            ? Colors.black
                            : Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    onTap: () {
                      ref
                          .read(defaultRecipientStateNotifier(widget.aliasId)
                              .notifier)
                          .toggleRecipient(verifiedRecipient);
                    },
                  );
                },
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                AppStrings.updateAliasRecipientNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 100),
          ],
        );
      },
      error: (err, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: ErrorMessageWidget(message: err.toString()),
        );
      },
      loading: () => const SizedBox(
        height: 100,
        child: PlatformLoadingIndicator(),
      ),
    );
  }
}
