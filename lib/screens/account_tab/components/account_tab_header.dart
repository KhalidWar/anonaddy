import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/screens/account_tab/components/header_profile.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:anonaddy/utilities/niche_method.dart';
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
            // PlatformAware.platformDialog(
            //   context: context,
            //   child: PlatformInfoDialog(
            //     content: Text('Test'),
            //     title: 'Test',
            //     buttonLabel: 'Cancel',
            //     // method: () {},
            //   ),
            // );
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
        // AccountListTile(
        //   title: account.defaultAliasDomain,
        //   subtitle: 'Default Alias Domain',
        //   leadingIconData: Icons.dns_outlined,
        //   trailingIcon: const Icon(
        //     Icons.open_in_new_outlined,
        //     color: Colors.white,
        //   ),
        //   onTap: () => updateDefaultAliasFormatDomain(ref),
        // ),
        // AccountListTile(
        //   title: account.defaultAliasFormat == null
        //       ? null
        //       : NicheMethod.correctAliasString(account.defaultAliasFormat!),
        //   subtitle: 'Default Alias Format',
        //   leadingIconData: Icons.alternate_email_outlined,
        //   trailingIcon: const Icon(
        //     Icons.open_in_new_outlined,
        //     color: Colors.white,
        //   ),
        //   onTap: () => updateDefaultAliasFormatDomain(ref),
        // ),
      ],
    );
  }

  Future<void> updateDefaultAliasFormatDomain(WidgetRef ref) async {
    final instanceURL = await ref.read(accessTokenService).getInstanceURL();
    await NicheMethod.launchURL('https://$instanceURL/settings');
  }
}
