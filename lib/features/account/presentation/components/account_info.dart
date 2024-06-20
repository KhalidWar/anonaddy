import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/components/account_info_tile.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage(name: 'AccountInfoRoute')
class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({super.key});

  static const accountInfoLoading = Key('accountInfoLoading');
  static const accountInfoError = Key('accountInfoLoading');

  @override
  ConsumerState createState() => _AccountInfoState();
}

class _AccountInfoState extends ConsumerState<AccountInfo> {
  String getSubscriptionExpirationDate(BuildContext context, Account account) {
    /// Self hosted instances do NOT have a subscription and do not expire.
    if (account.isSelfHosted) {
      return AppStrings.subscriptionEndDateDoesNotExpire;
    }

    /// addy.io free subscriptions do NOT expire.
    if (account.isSubscriptionFree) {
      return AppStrings.noSubscription;
    }

    /// addy.io Lite and Pro subscriptions do expire.
    return account.subscriptionEndAt.isEmpty
        ? AppStrings.subscriptionEndDateNotAvailable
        : 'expires on ${Utilities.formatDateTime(context, account.createdAt, showTime: false)}';
  }

  String getSubscriptionInfo(Account account) {
    final subscription = Utilities.capitalizeFirstLetter(
        account.isSelfHosted ? AppStrings.selfHosted : account.subscription);
    final expirationDate = getSubscriptionExpirationDate(context, account);
    return '$subscription, ($expirationDate)';
  }

  String getAccessTokenInfo(User user) {
    final expiration = Utilities.formatDateTime(
      context,
      user.apiToken.expiresAt,
      showTime: false,
    );
    final expiresOn =
        user.isSelfHosting ? 'does not expire' : 'expires on $expiration';
    return '${user.apiToken.name} ($expiresOn)';
  }

  /// addy.io instances' [recipientLimit] is not unlimited.
  /// It always returns an int value representing the max [recipientLimit].
  ///
  /// Self hosted instances' [recipientLimit] are unlimited.
  /// It returns [null] which means there's no value.
  String calculateRecipientsCount(Account account) {
    final limit = account.isSelfHosted ? '∞' : account.recipientLimit;
    return '${account.recipientCount} / $limit';
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
    final limit = account.isSelfHosted ? '∞' : account.usernameLimit;
    return '${account.usernameCount} / $limit';
  }

  String calculateDomainsCount(Account account) {
    final limit = account.isSelfHosted ? '∞' : account.activeDomainLimit;
    return '${account.activeDomainCount} / $limit';
  }

  String calculateRulesCount(Account account) {
    final limit = account.isSelfHosted ? '∞' : account.activeRuleLimit;
    return '${account.activeRuleCount} / $limit';
  }

  String getTotalAliasesCount(Account account) {
    final limit = account.isSelfHosted ? '∞' : account.aliasLimit;
    return '${account.totalAliases} / $limit';
  }

  String getActiveAliasesCount(Account account) {
    final limit = account.isSelfHosted ? '∞' : account.aliasLimit;
    return '${account.aliasCount} / $limit';
  }

  /// addy.io instances always have a [bandwidthLimit] value.
  /// If unlimited, it's "0". If not, it's an int.
  ///
  /// Self hosted instances do NOT have any [bandwidthLimit] value.
  /// So, it returns a [null] value which defaults to "0".
  double calculateBandWidth(Account account) {
    final bandwidth = account.bandwidth;
    final limit = account.bandwidthLimit;

    if (limit == 0) return 1 / 2;
    return bandwidth / limit;
  }

  Future<void> updateDefaultAliasFormatDomain(User? user) async {
    await Utilities.launchURL('https://${user?.url}/settings');
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountNotifierProvider);
    final authState = ref.watch(authNotifierProvider).requireValue;

    return Scaffold(
      body: accountState.when(
        data: (account) {
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                dense: true,
                leading: CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: AppColors.accentColor,
                  child: Text(
                    account.username[0].toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Utilities.capitalizeFirstLetter(account.username),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${authState.user!.url})',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                subtitle: Text(
                  getSubscriptionInfo(account),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
                trailing: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Manage Account',
                  icon: const Icon(Icons.manage_accounts_outlined),
                  onPressed: () {
                    updateDefaultAliasFormatDomain(authState.user);
                  },
                ),
              ),
              // Row(
              //   children: [
              //     AccountInfoTile(
              //       title: getAccessTokenInfo(authState.user!),
              //       subtitle: 'Access Token',
              //     ),
              //   ],
              // ),
              // const Divider(height: 40),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: calculateBandWidth(account),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accentColor,
                      ),
                      minHeight: 24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bandwidth (${DateFormat('MMM').format(DateTime.now())})',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        Text(
                          account.bandwidthLimit == 0
                              ? '∞ MB'
                              : '${(account.bandwidthLimit / 1048576).toStringAsFixed(0)} MB',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              // const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountInfoTile(
                    title: account.totalAliases.toString(),
                    subtitle: 'Total Aliases',
                  ),
                  AccountInfoTile(
                    title: account.totalActiveAliases.toString(),
                    subtitle: 'Active',
                  ),
                  AccountInfoTile(
                    title: account.totalInactiveAliases.toString(),
                    subtitle: 'Inactive',
                  ),
                  AccountInfoTile(
                    title: account.totalDeletedAliases.toString(),
                    subtitle: 'Deleted',
                  ),
                ],
              ),
              // const Divider(height: 24),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountInfoTile(
                    title: calculateRecipientsCount(account),
                    subtitle: AppStrings.recipients,
                  ),
                  AccountInfoTile(
                    title: calculateUsernamesCount(account),
                    subtitle: AppStrings.usernames,
                  ),
                  AccountInfoTile(
                    title: calculateDomainsCount(account),
                    subtitle: AppStrings.domains,
                  ),
                  AccountInfoTile(
                    title: calculateRulesCount(account),
                    subtitle: AppStrings.rules,
                  ),
                ],
              ),
              const Divider(height: 28),
              // const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountInfoTile(
                    title: account.defaultAliasFormat.isEmpty
                        ? AppStrings.noDefaultSelected
                        : Utilities.correctAliasString(
                            account.defaultAliasFormat),
                    subtitle: AppStrings.defaultAliasFormat,
                  ),
                  AccountInfoTile(
                    title: account.defaultAliasDomain.isEmpty
                        ? AppStrings.noDefaultSelected
                        : account.defaultAliasDomain,
                    subtitle: AppStrings.defaultAliasDomain,
                  ),
                ],
              ),
              // const Divider(height: 24),
            ],
          );
        },
        error: (err, _) => ErrorMessageWidget(
          key: AccountInfo.accountInfoError,
          message: err.toString(),
          messageColor: Colors.white,
        ),
        loading: () => const Center(
          child: PlatformLoadingIndicator(
            key: AccountInfo.accountInfoLoading,
          ),
        ),
      ),
    );
  }
}
