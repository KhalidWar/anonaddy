import 'package:anonaddy/models/account/account_model.dart';
import 'package:anonaddy/screens/account_tab/add_new_recipient.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_new_username.dart';

class MainAccount extends StatelessWidget {
  const MainAccount({Key? key, required this.account}) : super(key: key);
  final Account account;

  String _capitalize(String input) {
    final firstLetter = input[0];
    return input.replaceFirst(firstLetter, firstLetter.toUpperCase());
  }

  String _calculateBandWidth() {
    String isUnlimited(dynamic input, String unit) {
      return input == 0 ? 'unlimited' : '${input.hashCode.round()} $unit';
    }

    final bandwidth = (account.bandwidth / 1048576).toStringAsFixed(2);
    final bandwidthLimit = isUnlimited(account.bandwidthLimit / 1048576, 'MB');
    return '$bandwidth MB out of $bandwidthLimit';
  }

  @override
  Widget build(BuildContext context) {
    final subscription =
        context.read(accountStreamProvider).data!.value.account.subscription;
    final correctAliasString =
        context.read(aliasStateManagerProvider).correctAliasString;
    final nicheMethod = NicheMethod();
    final showToast = nicheMethod.showToast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _capitalize(account.username),
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(_capitalize(account.subscription)),
            ],
          ),
        ),
        Divider(height: 8),
        AccountListTile(
          title: _calculateBandWidth(),
          subtitle: 'Monthly Bandwidth',
          leadingIconData: Icons.speed_outlined,
        ),
        AccountListTile(
          title: account.defaultAliasDomain,
          subtitle: 'Default Alias Domain',
          leadingIconData: Icons.dns,
          trailingIconData: Icons.open_in_new_outlined,
          onTap: () => updateDefaultAliasFormatDomain(nicheMethod),
        ),
        AccountListTile(
          title: correctAliasString(account.defaultAliasFormat),
          subtitle: 'Default Alias Format',
          leadingIconData: Icons.alternate_email,
          trailingIconData: Icons.open_in_new_outlined,
          onTap: () => updateDefaultAliasFormatDomain(nicheMethod),
        ),
        AccountListTile(
          title: '${account.recipientCount} out of ${account.recipientLimit}',
          subtitle: 'Recipients',
          leadingIconData: Icons.email_outlined,
          trailingIconData: Icons.add_circle_outline_outlined,
          onTap: account.recipientCount == account.recipientLimit
              ? () => showToast(kReachedRecipientLimit)
              : () => buildAddNewRecipient(context),
        ),
        AccountListTile(
          title: '${account.usernameCount} out of ${account.usernameLimit}',
          subtitle: 'Usernames',
          leadingIconData: Icons.account_circle_outlined,
          trailingIconData: Icons.add_circle_outline_outlined,
          onTap: subscription == kFreeSubscription
              ? () => showToast(kOnlyAvailableToPaid)
              : account.usernameCount == account.usernameLimit
                  ? () => showToast(kReachedUsernameLimit)
                  : () => buildAddNewUsername(context),
        ),
      ],
    );
  }

  Future updateDefaultAliasFormatDomain(NicheMethod nicheMethod) async {
    await nicheMethod.launchURL(kAnonAddySettingsURL);
  }

  Future buildAddNewRecipient(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) => AddNewRecipient(),
    );
  }

  Future buildAddNewUsername(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) => AddNewUsername(),
    );
  }
}
