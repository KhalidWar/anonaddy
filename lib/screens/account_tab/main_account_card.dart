import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/account_card_header.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/card_header.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainAccountStream = StreamProvider.autoDispose<UserModel>((ref) async* {
  yield await ref.watch(userServiceProvider).getUserData();
  while (true) {
    await Future.delayed(Duration(seconds: 10));
    yield await ref.read(userServiceProvider).getUserData();
  }
});

class MainAccount extends ConsumerWidget {
  MainAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(mainAccountStream);

    return stream.when(
      loading: () => FetchingDataIndicator(),
      data: (data) => Card(
        child: Column(
          children: [
            CardHeader(label: 'Main'),
            AccountCardHeader(
              title: data.username,
              subtitle: '${data.subscription} subscription',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            AliasDetailListTile(
              title:
                  '${(data.bandwidth / 1000000).toStringAsFixed(2)} MB / ${NicheMethod().isUnlimited(data.bandwidthLimit, 'MD')}',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Monthly Bandwidth',
              leadingIconData: Icons.speed_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title: '${data.usernameCount} / ${data.usernameLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Add. Usernames',
                    leadingIconData: Icons.account_circle_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title: '${data.recipientCount} / ${data.recipientLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Recipients',
                    leadingIconData: Icons.account_circle_outlined,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${data.aliasCount} / ${NicheMethod().isUnlimited(data.aliasLimit, '')}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Active Aliases',
                    leadingIconData: Icons.email_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${data.activeDomainCount} / ${data.activeDomainLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Active Domain Count',
                    leadingIconData: Icons.dns,
                  ),
                ),
              ],
            ),
            AliasDetailListTile(
              title: data.id,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'ID',
              leadingIconData: Icons.perm_identity,
            ),
            Divider(height: 0),
            ExpansionTile(
              title: Text(
                'View defaults',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AliasDetailListTile(
                        title: data.defaultAliasDomain,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        subtitle: 'Default Alias Domain',
                        leadingIconData: Icons.dns,
                      ),
                    ),
                    Expanded(
                      child: AliasDetailListTile(
                        title: data.defaultAliasFormat,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        subtitle: 'Default Alias Format',
                        leadingIconData: Icons.alternate_email,
                      ),
                    ),
                  ],
                ),
                AliasDetailListTile(
                  title: data.defaultRecipientId,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Default Recipient ID',
                  leadingIconData: Icons.account_circle_outlined,
                ),
              ],
            )
          ],
        ),
      ),
      error: (error, stackTrace) => LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        label: "$error",
      ),
    );
  }
}
