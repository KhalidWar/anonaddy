import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/components/add_new_username.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_tab_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_tab_state.dart';
import 'package:anonaddy/features/usernames/presentation/username_list_tile.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernamesTab extends ConsumerStatefulWidget {
  const UsernamesTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _UsernamesTabState();
}

class _UsernamesTabState extends ConsumerState<UsernamesTab> {
  void addNewUsername(BuildContext context) {
    final accountState = ref.read(accountNotifierProvider).value!;

    /// Draws UI for adding new username
    Future buildAddNewUsername(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
          ),
        ),
        builder: (context) => const AddNewUsername(),
      );
    }

    if (accountState.isSelfHosted) {
      buildAddNewUsername(context);
    } else {
      if (accountState.isSubscriptionFree) {
        Utilities.showToast(ToastMessage.onlyAvailableToPaid);
      } else {
        accountState.hasUsernamesReachedLimit
            ? Utilities.showToast(AnonAddyString.reachedUsernameLimit)
            : buildAddNewUsername(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(usernameStateNotifier.notifier).loadOfflineState();
      ref.read(usernameStateNotifier.notifier).fetchUsernames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usernameState = ref.watch(usernameStateNotifier);

    switch (usernameState.status) {
      case UsernamesStatus.loading:
        return const RecipientsShimmerLoading();

      case UsernamesStatus.loaded:
        final usernames = usernameState.usernames;
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
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
                    itemBuilder: (_, index) {
                      return UsernameListTile(username: usernames[index]);
                    },
                  ),
            TextButton(
              child: const Text(AppStrings.addNewUsername),
              onPressed: () => addNewUsername(context),
            ),
          ],
        );

      case UsernamesStatus.failed:
        return ErrorMessageWidget(message: usernameState.errorMessage);
    }
  }
}
