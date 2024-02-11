import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPopupInfo extends ConsumerWidget {
  const AccountPopupInfo({
    Key? key,
    required this.account,
  }) : super(key: key);
  final Account account;

  String getSubscriptionExpirationDate(BuildContext context) {
    /// Self hosted instances do NOT have a subscription and do not expire.
    if (account.isSelfHosted) {
      return AppStrings.subscriptionEndDateDoesNotExpire;
    }

    /// addy.io free subscriptions do NOT expire.
    if (account.isSubscriptionFree) {
      return AppStrings.subscriptionEndDateDoesNotExpire;
    }

    /// addy.io Lite and Pro subscriptions do expire.
    return account.subscriptionEndAt.isEmpty
        ? AppStrings.subscriptionEndDateNotAvailable
        : Utilities.formatDateTime(context, account.createdAt);
  }

  Future<void> updateDefaultAliasFormatDomain(WidgetRef ref) async {
    final user = await ref.read(authServiceProvider).getUser();
    await Utilities.launchURL('https://${user!.url}/settings');
  }

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
            account.defaultAliasFormat.isEmpty
                ? AppStrings.noDefaultSelected
                : Utilities.correctAliasString(account.defaultAliasFormat),
          ),
          subtitle: const Text(AppStrings.defaultAliasFormat),
          trailing: const Icon(Icons.open_in_new_outlined),
          onTap: () => updateDefaultAliasFormatDomain(ref),
        ),
        ListTile(
          dense: true,
          title: Text(
            account.defaultAliasDomain.isEmpty
                ? AppStrings.noDefaultSelected
                : account.defaultAliasDomain,
          ),
          subtitle: const Text(AppStrings.defaultAliasDomain),
          trailing: const Icon(Icons.open_in_new_outlined),
          onTap: () => updateDefaultAliasFormatDomain(ref),
        ),
        ListTile(
          dense: true,
          title: Text(getSubscriptionExpirationDate(context)),
          subtitle: const Text(AppStrings.subscriptionEndDate),
        ),
      ],
    );
  }
}
