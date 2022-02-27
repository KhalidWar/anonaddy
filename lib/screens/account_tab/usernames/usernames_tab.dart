import 'package:anonaddy/screens/account_tab/components/add_new_username.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_list_tile.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_notifier.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernamesTab extends ConsumerStatefulWidget {
  const UsernamesTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _UsernamesTabState();
}

class _UsernamesTabState extends ConsumerState<UsernamesTab> {
  void addNewUsername(BuildContext context) {
    final account = ref.read(accountStateNotifier).account;

    /// Draws UI for adding new username
    Future buildAddNewUsername(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius),
          ),
        ),
        builder: (context) => const AddNewUsername(),
      );
    }

    /// If account data is unavailable, show an error message and exit method.
    if (account == null) {
      NicheMethod.showToast(AppStrings.loadAccountDataFailed);
      return;
    }

    if (account.subscription == null) {
      buildAddNewUsername(context);
    } else {
      if (account.subscription == AnonAddyString.subscriptionFree) {
        NicheMethod.showToast(ToastMessage.onlyAvailableToPaid);
      } else {
        account.usernameCount == account.usernameLimit
            ? NicheMethod.showToast(AnonAddyString.reachedUsernameLimit)
            : buildAddNewUsername(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountStateNotifier);

    switch (accountState.status) {
      case AccountStatus.loading:
        return const RecipientsShimmerLoading();

      case AccountStatus.loaded:
        final subscription = accountState.account!.subscription;
        if (subscription == AnonAddyString.subscriptionFree) {
          return const PaidFeatureWall();
        }

        final usernameState = ref.watch(usernameStateNotifier);
        switch (usernameState.status) {
          case UsernamesStatus.loading:
            return const RecipientsShimmerLoading();

          case UsernamesStatus.loaded:
            final usernames = usernameState.usernameModel!.usernames;

            return ListView(
              shrinkWrap: true,
              children: [
                usernames.isEmpty
                    ? ListTile(
                        title: Center(
                          child: Text(
                            AppStrings.noAdditionalUsernamesFound,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        itemCount: usernames.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final username = usernames[index];
                          return UsernameListTile(username: username);
                        },
                      ),
                TextButton(
                  child: const Text(AppStrings.addNewUsername),
                  onPressed: () => addNewUsername(context),
                ),
              ],
            );

          case UsernamesStatus.failed:
            final error = usernameState.errorMessage;
            return LottieWidget(
              lottie: LottieImages.errorCone,
              lottieHeight: MediaQuery.of(context).size.height * 0.1,
              label: error.toString(),
            );
        }

      case AccountStatus.failed:
        return LottieWidget(
          lottie: LottieImages.errorCone,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: AppStrings.loadAccountDataFailed,
        );
    }
  }
}
