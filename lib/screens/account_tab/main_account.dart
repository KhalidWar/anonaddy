import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/screens/account_tab/add_new_recipient.dart';
import 'package:anonaddy/shared_components/account_list_tile.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_new_username.dart';

class MainAccount extends StatelessWidget {
  const MainAccount({Key key, this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final subscription =
        context.read(accountStreamProvider).data.value.subscription;
    final showToast = context.read(usernameStateManagerProvider).showToast;

    return Padding(
      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${userModel.username.replaceFirst(userModel.username[0], userModel.username[0].toUpperCase())}',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                userModel.subscription.replaceFirst(userModel.subscription[0],
                    userModel.subscription[0].toUpperCase()),
              ),
            ],
          ),
          Divider(),
          AccountListTile(
            title:
                '${(userModel.bandwidth / 1000000).toStringAsFixed(2)} MB out of ${NicheMethod().isUnlimited(userModel.bandwidthLimit / 1000000, 'MB')}',
            subtitle: 'Monthly Bandwidth',
            leadingIconData: Icons.speed_outlined,
          ),
          AccountListTile(
            title: userModel.defaultAliasDomain,
            subtitle: 'Default Alias Domain',
            leadingIconData: Icons.dns,
            trailingIconData: Icons.open_in_new_outlined,
            method: () => updateDefaultAliasFormatDomain(context, showToast),
          ),
          AccountListTile(
            title: userModel.defaultAliasFormat,
            subtitle: 'Default Alias Format',
            leadingIconData: Icons.alternate_email,
            trailingIconData: Icons.open_in_new_outlined,
            method: () => updateDefaultAliasFormatDomain(context, showToast),
          ),
          AccountListTile(
            title:
                '${userModel.recipientCount} out of ${userModel.recipientLimit} used',
            subtitle: 'Recipients',
            leadingIconData: Icons.email_outlined,
            trailingIconData: Icons.add_circle_outline_outlined,
            method: userModel.recipientCount == userModel.recipientLimit
                ? () => showToast(kReachedRecipientLimit)
                : () => buildAddNewRecipient(context),
          ),
          AccountListTile(
            title:
                '${userModel.usernameCount} out of ${userModel.usernameLimit} used',
            subtitle: 'Usernames',
            leadingIconData: Icons.account_circle_outlined,
            trailingIconData: Icons.add_circle_outline_outlined,
            method: subscription == 'free'
                ? () => showToast(kOnlyAvailableToPaid)
                : userModel.usernameCount == userModel.usernameLimit
                    ? () => showToast(kReachedUsernameLimit)
                    : () => buildAddNewUsername(context),
          ),
        ],
      ),
    );
  }

  Future updateDefaultAliasFormatDomain(
      BuildContext context, Function showToast) async {
    await launch(kAnonAddySettingsURL).catchError((error, stackTrace) {
      throw showToast(error.toString());
    });
  }

  Future buildAddNewRecipient(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddNewRecipient(),
    );
  }

  Future buildAddNewUsername(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddNewUsername();
      },
    );
  }
}
