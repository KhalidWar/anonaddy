import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/username_state_manager.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/custom_page_route.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../app_settings/app_settings.dart';
import 'add_new_recipient.dart';

final recipientStreamProvider =
    StreamProvider.autoDispose<RecipientModel>((ref) async* {
  final offlineData = ref.read(offlineDataProvider);
  while (true) {
    yield* Stream.fromFuture(
        ref.read(recipientServiceProvider).getAllRecipient(offlineData));
    await Future.delayed(Duration(seconds: 5));
  }
});

class MoreTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final recipientStream = watch(recipientStreamProvider);
    final accountStream = watch(accountStreamProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // todo implement feedback mechanism.
          // todo Give dev email to receive feedback and suggestions
          // todo encourage users to get into beta program

          recipientStream.when(
            loading: () => LoadingIndicator(),
            data: (data) {
              final recipientList = data.recipientDataList;

              return accountStream.when(
                loading: () => Container(),
                data: (userModelData) {
                  final usernameCount = userModelData.recipientCount;
                  final usernameLimit = userModelData.recipientLimit;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recipients',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                              '${userModelData.recipientCount} / ${NicheMethod().isUnlimited(userModelData.recipientLimit, '')}'),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline_outlined),
                            onPressed: usernameCount == usernameLimit
                                ? () => context
                                    .read(usernameStateManagerProvider)
                                    .showToast(kReachedRecipientLimit)
                                : () => buildShowModalBottomSheet(context),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recipientList.length,
                        itemBuilder: (context, index) {
                          return RecipientListTile(
                            recipientDataModel: recipientList[index],
                          );
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                },
                error: (error, stackTrace) => Text(''),
              );
            },
            error: (error, stackTrace) {
              return LottieWidget(
                showLoading: true,
                lottie: 'assets/lottie/errorCone.json',
                label: '$error',
              );
            },
          ),
          Divider(height: 10),
          ListTile(
            contentPadding:
                EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 12),
            title: Text(
              'App Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Icon(Icons.settings),
            onTap: () =>
                Navigator.push(context, CustomPageRoute(AppSettings())),
          ),
        ],
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddNewRecipient(),
    );
  }
}
