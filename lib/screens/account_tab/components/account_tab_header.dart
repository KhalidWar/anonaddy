import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/screens/account_tab/components/account_popup_info.dart';
import 'package:anonaddy/screens/account_tab/components/account_tab_widget_keys.dart';
import 'package:anonaddy/screens/account_tab/components/header_profile.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_info_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTabHeader extends ConsumerStatefulWidget {
  const AccountTabHeader({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AccountTabHeaderState();
}

class _AccountTabHeaderState extends ConsumerState<AccountTabHeader> {
  /// addy.io instances always have a [bandwidthLimit] value.
  /// If unlimited, it's "0". If not, it's an int.
  ///
  /// Self hosted instances do NOT have any [bandwidthLimit] value.
  /// So, it returns a [null] value which defaults to "0".
  String calculateBandWidth(Account account) {
    final bandwidth = (account.bandwidth / 1048576).toStringAsFixed(2);

    if (account.isSelfHosted) {
      return '$bandwidth MB out of ${AppStrings.unlimited}';
    } else {
      final bandwidthLimit =
          ((account.bandwidthLimit) / 1048576).toStringAsFixed(2);
      return '$bandwidth out of $bandwidthLimit MB';
    }
  }

  /// addy.io instances' [recipientLimit] is not unlimited.
  /// It always returns an int value representing the max [recipientLimit].
  ///
  /// Self hosted instances' [recipientLimit] are unlimited.
  /// It returns [null] which means there's no value.
  String calculateRecipientsCount(Account account) {
    return account.isSelfHosted
        ? '${account.recipientCount} out of ${AppStrings.unlimited}'
        : '${account.recipientCount} out of ${account.recipientLimit}';
  }

  /// addy.io instances' [usernameLimit] is not unlimited.
  /// It always returns an int value representing the max [usernameLimit].
  /// [Username] is a paid feature NOT available for "free" users.
  /// Free users have a [usernameLimit] of "0".
  /// Paid users have a int value representing [usernameLimit].
  ///
  /// Self hosted instances' [usernameLimit] are unlimited.
  /// It returns [null] which means there's no value.
  String calculateUsernamesCount(Account account) {
    return account.isSelfHosted
        ? '${account.usernameCount} out of ${AppStrings.unlimited}'
        : '${account.usernameCount} out of ${account.usernameLimit}';
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Initially load data from disk (secured device storage)
      // ref.read(accountNotifierProvider.notifier).loadAccountFromDisk();

      /// Fetch latest data from server
      ref.read(accountNotifierProvider.notifier).fetchAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountNotifierProvider);

    return accountState.when(
      data: (account) {
        return ListView(
          children: [
            HeaderProfile(
              key: AccountTabWidgetKeys.accountTabHeaderHeaderProfile,
              account: account,
              onPress: () {
                PlatformAware.platformDialog(
                  context: context,
                  child: PlatformInfoDialog(
                    title: AppStrings.accountBotNavLabel,
                    buttonLabel: AppStrings.doneText,
                    content: AccountPopupInfo(account: account),
                  ),
                );
              },
            ),
            AccountListTile(
              title: calculateBandWidth(account),
              subtitle: AppStrings.monthlyBandwidth,
              leadingIconData: Icons.speed_outlined,
            ),
            AccountListTile(
              title: calculateRecipientsCount(account),
              subtitle: AppStrings.recipients,
              leadingIconData: Icons.email_outlined,
            ),
            AccountListTile(
              title: calculateUsernamesCount(account),
              subtitle: AppStrings.usernames,
              leadingIconData: Icons.account_circle_outlined,
            ),
          ],
        );
      },
      error: (err, _) => ErrorMessageWidget(
        key: AccountTabWidgetKeys.accountTabHeaderError,
        message: err.toString(),
        messageColor: Colors.white,
      ),
      loading: () => const Center(
        child: PlatformLoadingIndicator(
          key: AccountTabWidgetKeys.accountTabHeaderLoading,
        ),
      ),
    );
  }
}
