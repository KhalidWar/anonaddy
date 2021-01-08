import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/screens/recipient_screen/recipient_detailed_screen.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:anonaddy/widgets/account_card_header.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/card_header.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final additionalUsernameStream =
    StreamProvider.autoDispose<UsernameModel>((ref) async* {
  yield await ref.watch(usernameServiceProvider).getUsernameData();
  while (true) {
    await Future.delayed(Duration(seconds: 10));
    yield await ref.watch(usernameServiceProvider).getUsernameData();
  }
});

class AdditionalUsernameCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(additionalUsernameStream);

    return stream.when(
      loading: () => FetchingDataIndicator(),
      data: (data) {
        if (data.usernameDataList.isEmpty) {
          return Card(
            child: Column(
              children: [
                CardHeader(label: 'Additional Username'),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    'No additional usernames found',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                //todo add add username function
              ],
            ),
          );
        }
        return buildListView(context, data);
      },
      error: (error, stackTrace) => LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        label: '$error',
      ),
    );
  }

  ListView buildListView(BuildContext context, UsernameModel data) {
    final aliasDataProvider = context.read(aliasStateManagerProvider);
    final recipientDataProvider = context.read(recipientStateManagerProvider);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.usernameDataList.length,
      itemBuilder: (context, index) {
        final username = data.usernameDataList[index];
        return Card(
          child: Column(
            children: [
              CardHeader(label: 'Additional Username'),
              Column(
                children: [
                  AccountCardHeader(
                    title: '${data.usernameDataList[index].username}',
                    subtitle: '${data.usernameDataList[index].description}',
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AliasDetailListTile(
                          title: username.active == true ? 'Yes' : 'No',
                          titleTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          subtitle: 'Is active?',
                          leadingIconData: Icons.toggle_off_outlined,
                        ),
                      ),
                      Expanded(
                        child: AliasDetailListTile(
                          title: username.catchAll == true ? 'Yes' : 'No',
                          titleTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          subtitle: 'Is catch all?',
                          leadingIconData: Icons.repeat,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AliasDetailListTile(
                          title: username.createdAt,
                          titleTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          subtitle: 'Created at',
                          leadingIconData: Icons.access_time_outlined,
                        ),
                      ),
                      Expanded(
                        child: AliasDetailListTile(
                          title: username.updatedAt,
                          titleTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          subtitle: 'Updated at',
                          leadingIconData: Icons.av_timer_outlined,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 0),
                  ExpansionTile(
                    title: Text('Aliases',
                        style: Theme.of(context).textTheme.bodyText1),
                    children: [
                      username.aliases.isEmpty
                          ? Container(
                              padding: EdgeInsets.all(20),
                              child: Text('No aliases found'))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: username.aliases.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  horizontalTitleGap: 0,
                                  leading: Icon(Icons.alternate_email),
                                  title:
                                      Text('${username.aliases[index].email}'),
                                  subtitle: Text(
                                      '${username.aliases[index].emailDescription}'),
                                  onTap: () {
                                    aliasDataProvider.setAliasDataModel =
                                        username.aliases[index];
                                    aliasDataProvider.setSwitchValue(
                                        username.aliases[index].isAliasActive);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AliasDetailScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                  Divider(height: 0),
                  ExpansionTile(
                    title: Text('Default Recipient',
                        style: Theme.of(context).textTheme.bodyText1),
                    children: [
                      username.defaultRecipient.email == 'tempSolution'
                          ? Container(
                              padding: EdgeInsets.all(20),
                              child: Text('No default recipient found'),
                            )
                          : ListTile(
                              dense: true,
                              horizontalTitleGap: 0,
                              leading: Icon(Icons.account_circle_outlined),
                              title: Text('${username.defaultRecipient.email}'),
                              subtitle:
                                  Text('${username.defaultRecipient.userId}'),
                              onTap: () {
                                recipientDataProvider.setRecipientData(
                                    username.defaultRecipient);
                                recipientDataProvider.setEncryptionSwitch(
                                    username.defaultRecipient.shouldEncrypt);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RecipientDetailedScreen(
                                        recipientData:
                                            username.defaultRecipient,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
