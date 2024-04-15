import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPopupInfo extends ConsumerWidget {
  const AccountPopupInfo({
    super.key,
    required this.account,
  });

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

  Future<void> updateDefaultAliasFormatDomain(User? user) async {
    await Utilities.launchURL('https://${user?.url}/settings');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateNotifier).value!.user!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        Utilities.capitalizeFirstLetter(account.username),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${user.url})',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Text(
                    'Access token: ${user.apiToken.name}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    user.isSelfHosting
                        ? 'Token does not expire'
                        : 'Expires at: ${Utilities.formatDateTime(context, user.apiToken.expiresAt, showTime: false)}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              // const Spacer(),
              // const Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
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
          onTap: () => updateDefaultAliasFormatDomain(user),
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
          onTap: () => updateDefaultAliasFormatDomain(user),
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
