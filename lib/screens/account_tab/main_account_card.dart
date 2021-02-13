import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountStreamProvider =
    StreamProvider.autoDispose<UserModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(userServiceProvider).getUserData());
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield* Stream.fromFuture(ref.read(userServiceProvider).getUserData());
  }
});

class MainAccount extends ConsumerWidget {
  MainAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final accountStream = watch(accountStreamProvider);

    return accountStream.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
              child: Text(
                '${data.username.replaceFirst(data.username[0], data.username[0].toUpperCase())}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 10),
            AliasDetailListTile(
              title: data.subscription.replaceFirst(
                  data.subscription[0], data.subscription[0].toUpperCase()),
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Subscription',
              leadingIconData: Icons.attach_money_outlined,
            ),
            AliasDetailListTile(
              title:
                  '${(data.bandwidth / 1000000).toStringAsFixed(2)} MB / ${NicheMethod().isUnlimited(data.bandwidthLimit / 1000000, 'MB')}',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Monthly Bandwidth',
              leadingIconData: Icons.speed_outlined,
            ),
            AliasDetailListTile(
              title: data.defaultAliasDomain,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Default Alias Domain',
              leadingIconData: Icons.dns,
            ),
            AliasDetailListTile(
              title: data.defaultAliasFormat,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Default Alias Format',
              leadingIconData: Icons.alternate_email,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        );
      },
      error: (error, stackTrace) {
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          label: "$error",
        );
      },
    );
  }

  Future buildUpdateDefaultAliasDomain(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  thickness: 3,
                  indent: size.width * 0.4,
                  endIndent: size.width * 0.4,
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Create new alias',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(thickness: 1),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ),
        );
      },
    );
  }
}
