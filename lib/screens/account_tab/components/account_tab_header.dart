import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/screens/account_tab/components/account_popup_info.dart';
import 'package:anonaddy/screens/account_tab/components/header_profile.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_info_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTabHeader extends ConsumerStatefulWidget {
  const AccountTabHeader({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AccountTabHeaderState();
}

class _AccountTabHeaderState extends ConsumerState<AccountTabHeader> {
  String _calculateBandWidth(Account account) {
    /// AnonAddy instances always have a [bandwidthLimit] value.
    /// If unlimited, it's "0". If not, it's an int.
    /// Self hosted instances do NOT have any [bandwidthLimit] value.
    if (account.bandwidthLimit == null || account.bandwidthLimit == 0) {
      return AppStrings.unlimited;
    } else {
      final bandwidth = (account.bandwidth / 1048576).toStringAsFixed(2);
      final bandwidthLimit =
          ((account.bandwidthLimit ?? 0) / 1048576).toStringAsFixed(2);
      return '$bandwidth out of $bandwidthLimit MB';
    }
  }

  String _calculateRecipientsCount(Account account, bool isSelfHosted) {
    if (isSelfHosted) {
      return AppStrings.unlimited;
    } else {
      return '${account.recipientCount} out of ${account.recipientLimit}';
    }
  }

  String _calculateUsernamesCount(Account account, bool isSelfHosted) {
    if (isSelfHosted) {
      return AppStrings.unlimited;
    } else {
      return '${account.usernameCount} out of ${account.usernameLimit}';
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      /// Initially load data from disk (secured device storage)
      ref.read(accountStateNotifier.notifier).loadOfflineData();

      /// Fetch latest data from server
      ref.read(accountStateNotifier.notifier).fetchAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final accountState = ref.watch(accountStateNotifier);
    switch (accountState.status) {
      case AccountStatus.loading:
        return const Center(
          child: PlatformLoadingIndicator(),
        );

      case AccountStatus.loaded:
        final account = accountState.account;
        final isSelfHosted = accountState.isSelfHosted;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderProfile(
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
              title: _calculateBandWidth(account),
              subtitle: AppStrings.monthlyBandwidth,
              leadingIconData: Icons.speed_outlined,
            ),
            AccountListTile(
              title: _calculateRecipientsCount(account, isSelfHosted),
              subtitle: AppStrings.recipients,
              leadingIconData: Icons.email_outlined,
            ),
            AccountListTile(
              title: _calculateUsernamesCount(account, isSelfHosted),
              subtitle: AppStrings.usernames,
              leadingIconData: Icons.account_circle_outlined,
            ),
          ],
        );

      case AccountStatus.failed:
        return LottieWidget(
          showLoading: true,
          lottie: LottieImages.errorCone,
          lottieHeight: size.height * 0.2,
          label: accountState.errorMessage,
        );
    }
  }
}
