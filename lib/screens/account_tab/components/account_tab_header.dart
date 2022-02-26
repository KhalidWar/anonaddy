import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/screens/account_tab/components/account_popup_info.dart';
import 'package:anonaddy/screens/account_tab/components/header_profile.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_info_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTabHeader extends ConsumerWidget {
  const AccountTabHeader({
    Key? key,
    required this.account,
    required this.isSelfHosted,
  }) : super(key: key);

  final Account account;
  final bool isSelfHosted;

  String _calculateBandWidth() {
    String isUnlimited(dynamic input, String unit) {
      return input == 0 ? 'unlimited' : '${input.hashCode.round()} $unit';
    }

    final bandwidth = (account.bandwidth / 1048576).toStringAsFixed(2);
    final bandwidthLimit =
        isUnlimited(account.bandwidthLimit ?? 0 / 1048576, 'MB');
    return '$bandwidth MB out of $bandwidthLimit';
  }

  String _calculateRecipientsCount() {
    if (isSelfHosted) {
      return 'Unlimited';
    } else {
      return '${account.recipientCount} out of ${account.recipientLimit}';
    }
  }

  String _calculateUsernamesCount() {
    if (isSelfHosted) {
      return 'Unlimited';
    } else {
      return '${account.usernameCount} out of ${account.usernameLimit}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderProfile(
          account: account,
          onPress: () {
            PlatformAware.platformDialog(
              context: context,
              child: PlatformInfoDialog(
                title: AddyManagerString.accountBotNavLabel,
                buttonLabel: AddyManagerString.doneText,
                content: AccountPopupInfo(account: account),
              ),
            );
          },
        ),
        AccountListTile(
          title: _calculateBandWidth(),
          subtitle: 'Monthly Bandwidth',
          leadingIconData: Icons.speed_outlined,
        ),
        AccountListTile(
          title: _calculateRecipientsCount(),
          subtitle: 'Recipients',
          leadingIconData: Icons.email_outlined,
        ),
        AccountListTile(
          title: _calculateUsernamesCount(),
          subtitle: 'Usernames',
          leadingIconData: Icons.account_circle_outlined,
        ),
      ],
    );
  }
}
