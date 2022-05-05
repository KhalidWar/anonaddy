import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPopupInfo extends ConsumerWidget {
  const AccountPopupInfo({
    Key? key,
    required this.accountState,
  }) : super(key: key);
  final AccountState accountState;

  String getSubscriptionExpirationDate() {
    /// Self hosted instances do NOT have a subscription and do not expire.
    if (accountState.isSelfHosted) {
      return AppStrings.subscriptionEndDateDoesNotExpire;
    }

    /// AnonAddy free subscriptions do NOT expire.
    if (accountState.isSubscriptionFree) {
      return AppStrings.subscriptionEndDateDoesNotExpire;
    }

    /// AnonAddy Lite and Pro subscriptions do expire.
    return NicheMethod.fixDateTime(
      accountState.account.subscriptionEndAt ??
          AppStrings.subscriptionEndDateNotAvailable,
    );
  }

  Future<void> updateDefaultAliasFormatDomain(WidgetRef ref) async {
    final instanceURL =
        await ref.read(accessTokenServiceProvider).getInstanceURL();
    await NicheMethod.launchURL('https://$instanceURL/settings');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = accountState.account;

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
}
