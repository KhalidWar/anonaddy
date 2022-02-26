import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
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
          title: account.defaultAliasFormat == null
              ? const Text(AddyManagerString.noDefaultSelected)
              : NicheMethod.correctAliasString(account.defaultAliasFormat!),
          subtitle: const Text(AddyManagerString.defaultAliasFormat),
          trailing: const Icon(Icons.open_in_new_outlined),
          onTap: () => updateDefaultAliasFormatDomain(ref),
        ),
        ListTile(
          dense: true,
          title: Text(
            account.defaultAliasDomain ?? AddyManagerString.noDefaultSelected,
          ),
          subtitle: const Text(AddyManagerString.defaultAliasDomain),
          trailing: const Icon(Icons.open_in_new_outlined),
          onTap: () => updateDefaultAliasFormatDomain(ref),
        ),
        ListTile(
          dense: true,
          title: Text(
            account.subscriptionEndAt == null
                ? 'Self Hosted'
                : NicheMethod.fixDateTime(account.subscriptionEndAt),
          ),
          subtitle: const Text('Subscription end date'),
        ),
      ],
    );
  }

  Future<void> updateDefaultAliasFormatDomain(WidgetRef ref) async {
    final instanceURL = await ref.read(accessTokenService).getInstanceURL();
    await NicheMethod.launchURL('https://$instanceURL/settings');
  }
}
