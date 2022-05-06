import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPopupInfo extends ConsumerWidget {
  const AccountPopupInfo({Key? key, required this.account}) : super(key: key);
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          tileColor: Colors.transparent,
          title: Text(
            account.defaultAliasFormat == null
                ? AppStrings.noDefaultSelected
                : NicheMethod.correctAliasString(account.defaultAliasFormat!),
          ),
          subtitle: const Text(AppStrings.defaultAliasFormat),
          trailing: const Icon(Icons.open_in_new_outlined),
          onTap: () => updateDefaultAliasFormatDomain(ref),
        ),
        ListTile(
          dense: true,
          title: Text(
            account.defaultAliasDomain ?? AppStrings.noDefaultSelected,
          ),
          subtitle: const Text(AppStrings.defaultAliasDomain),
          trailing: const Icon(Icons.open_in_new_outlined),
          onTap: () => updateDefaultAliasFormatDomain(ref),
        ),
        ListTile(
          dense: true,
          title: Text(getSubscriptionExpirationDate()),
          subtitle: const Text(AppStrings.subscriptionEndDate),
        ),
      ],
    );
  }

  String getSubscriptionExpirationDate() {
    final subscription = account.subscription;

    /// Self hosted does NOT have a subscription and does not expire
    if (subscription == null) {
      return AppStrings.selfHosted;
    }

    /// Free subscription does NOT expire
    if (subscription == AnonAddyString.subscriptionFree) {
      return 'Does not expire';
    }

    /// Lite and Pro subscription expire
    final liteSubscription = subscription == AnonAddyString.subscriptionLite;
    final proSubscription = subscription == AnonAddyString.subscriptionPro;
    if (liteSubscription || proSubscription) {
      return NicheMethod.fixDateTime(
        account.subscriptionEndAt ?? AppStrings.subscriptionEndDateNotAvailable,
      );
    }

    return AppStrings.subscriptionEndDateNotAvailable;
  }

  Future<void> updateDefaultAliasFormatDomain(WidgetRef ref) async {
    final instanceURL =
        await ref.read(accessTokenServiceProvider).getInstanceURL();
    await NicheMethod.launchURL('https://$instanceURL/settings');
  }
}
