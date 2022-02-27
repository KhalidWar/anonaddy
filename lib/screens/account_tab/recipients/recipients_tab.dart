import 'package:anonaddy/screens/account_tab/components/add_new_recipient.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientsTab extends ConsumerStatefulWidget {
  const RecipientsTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _RecipientTabState();
}

class _RecipientTabState extends ConsumerState<RecipientsTab> {
  void addNewRecipient(BuildContext context) {
    final account = ref.read(accountStateNotifier).account;

    /// Draws UI for adding new recipient
    Future buildAddNewRecipient(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius),
          ),
        ),
        builder: (context) => const AddNewRecipient(),
      );
    }

    /// If account data is unavailable, show an error message and exit method.
    if (account == null) {
      NicheMethod.showToast(AppStrings.loadAccountDataFailed);
      return;
    }

    if (account.subscription == null) {
      buildAddNewRecipient(context);
    } else {
      account.recipientCount == account.recipientLimit
          ? NicheMethod.showToast(AnonAddyString.reachedRecipientLimit)
          : buildAddNewRecipient(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ref.read(recipientTabStateNotifier.notifier).fetchRecipients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipientTabState = ref.watch(recipientTabStateNotifier);
    final size = MediaQuery.of(context).size;

    switch (recipientTabState.status) {
      case RecipientTabStatus.loading:
        return const RecipientsShimmerLoading();

      case RecipientTabStatus.loaded:
        final recipients = recipientTabState.recipients!;

        return ListView(
          shrinkWrap: true,
          children: [
            recipients.isEmpty
                ? ListTile(
                    title: Center(
                      child: Text(
                        AppStrings.noRecipientsFound,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.004),
                    itemCount: recipients.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final recipient = recipients[index];
                      return RecipientListTile(recipient: recipient);
                    },
                  ),
            TextButton(
              child: const Text(AppStrings.addNewRecipient),
              onPressed: () => addNewRecipient(context),
            ),
          ],
        );

      case RecipientTabStatus.failed:
        final error = recipientTabState.errorMessage;
        return LottieWidget(
          showLoading: true,
          lottie: LottieImages.errorCone,
          lottieHeight: size.height * 0.1,
          label: error.toString(),
        );
    }
  }
}
