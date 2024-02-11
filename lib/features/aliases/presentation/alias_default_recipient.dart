import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_notifier.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
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
    required this.defaultRecipients,
    required this.selectedRecipients,
  }) : super(key: key);

  final List<String> defaultRecipients;
  final List<String> selectedRecipients;

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
      ref.read(recipientsNotifier.notifier).fetchRecipients(showLoading: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipientState = ref.watch(recipientsNotifier);

    return recipientState.when(
      data: (recipients) {
        final verifiedRecipients =
            recipients.where((recipient) => recipient.isVerified).toList();

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
                  final isDefault =
                      widget.defaultRecipients.contains(verifiedRecipient.id);
                  // widget.defaultRecipients.contains(verifiedRecipient);
                  // ref
                  //     .read(aliasScreenNotifierProvider('').notifier)
                  //     .isRecipientDefault(verifiedRecipient);

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
                          .read(defaultRecipientStateNotifier.notifier)
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
