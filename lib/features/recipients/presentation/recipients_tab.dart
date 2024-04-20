import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/common/shimmer_effects/shimmering_list_tile.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/recipients/presentation/components/add_new_recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RecipientsTab extends ConsumerStatefulWidget {
  const RecipientsTab({super.key});

  @override
  ConsumerState createState() => _RecipientTabState();
}

class _RecipientTabState extends ConsumerState<RecipientsTab> {
  void addNewRecipient(BuildContext context) {
    final accountState = ref.read(accountNotifierProvider).value;
    if (accountState == null) return;

    /// Draws UI for adding new recipient
    Future<void> buildAddNewRecipient() async {
      await WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) {
          return [
            Utilities.buildWoltModalSheetSubPage(
              context,
              topBarTitle: AppStrings.addNewRecipient,
              child: const AddNewRecipient(),
            ),
          ];
        },
      );
    }

    if (accountState.isSelfHosted) {
      buildAddNewRecipient();
    } else {
      accountState.hasRecipientsReachedLimit
          ? Utilities.showToast(AddyString.reachedRecipientLimit)
          : buildAddNewRecipient();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(recipientsNotifierProvider.notifier).fetchRecipients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipientsState = ref.watch(recipientsNotifierProvider);

    return recipientsState.when(
      data: (recipients) {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            recipients.isEmpty
                ? const ListTile(
                    title: Center(
                      child: Text(AppStrings.noRecipientsFound),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipients.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final recipient = recipients[index];
                      return RecipientListTile(
                        recipient: recipient,
                        onPress: () {
                          Navigator.pushNamed(
                            context,
                            RecipientsScreen.routeName,
                            arguments: recipient.id,
                          );
                        },
                      );
                    },
                  ),
            TextButton(
              child: const Text(AppStrings.addNewRecipient),
              onPressed: () => addNewRecipient(context),
            ),
          ],
        );
      },
      error: (err, _) => ErrorMessageWidget(message: err.toString()),
      loading: () => const ShimmeringListTile(),
    );
  }
}
