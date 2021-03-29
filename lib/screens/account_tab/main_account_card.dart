import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/screens/search_tab/add_new_recipient.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/username_state_manager.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/account_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

final accountStreamProvider =
    StreamProvider.autoDispose<UserModel>((ref) async* {
  final offlineData = ref.read(offlineDataProvider);
  while (true) {
    yield* Stream.fromFuture(
        ref.read(userServiceProvider).getUserData(offlineData));
    await Future.delayed(Duration(seconds: 5));
  }
});

class AccountWidget extends StatelessWidget {
  const AccountWidget({Key key, this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${userModel.username.replaceFirst(userModel.username[0], userModel.username[0].toUpperCase())}',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                userModel.subscription.replaceFirst(userModel.subscription[0],
                    userModel.subscription[0].toUpperCase()),
              ),
            ],
          ),
          SizedBox(height: 10),
          AccountListTile(
            title:
                '${(userModel.bandwidth / 1000000).toStringAsFixed(2)} MB / ${NicheMethod().isUnlimited(userModel.bandwidthLimit / 1000000, 'MB')}',
            subtitle: 'Monthly Bandwidth',
            leadingIconData: Icons.speed_outlined,
          ),
          AccountListTile(
            title: userModel.defaultAliasDomain,
            subtitle: 'Default Alias Domain',
            leadingIconData: Icons.dns,
            trailingIconData: Icons.open_in_new_outlined,
            method: () => updateDefaultAliasFormatDomain(context),
          ),
          AccountListTile(
            title: userModel.defaultAliasFormat,
            subtitle: 'Default Alias Format',
            leadingIconData: Icons.alternate_email,
            trailingIconData: Icons.open_in_new_outlined,
            method: () => updateDefaultAliasFormatDomain(context),
          ),
          AccountListTile(
            title:
                '${userModel.recipientCount} out of ${userModel.recipientLimit} used',
            subtitle: 'Recipients',
            leadingIconData: Icons.email_outlined,
            trailingIconData: Icons.add_circle_outline_outlined,
            method: userModel.recipientCount == userModel.recipientLimit
                ? () => context
                    .read(usernameStateManagerProvider)
                    .showToast(kReachedRecipientLimit)
                : () => buildAddNewRecipient(context),
          ),
          AccountListTile(
            title:
                '${userModel.usernameCount} out of ${userModel.usernameLimit} used',
            subtitle: 'Usernames',
            leadingIconData: Icons.email_outlined,
            trailingIconData: Icons.add_circle_outline_outlined,
            method: userModel.usernameCount == userModel.usernameLimit
                ? () => context
                    .read(usernameStateManagerProvider)
                    .showToast(kReachedUsernameLimit)
                : () => buildAddNewUsername(context),
          ),
        ],
      ),
    );
  }

  Future updateDefaultAliasFormatDomain(BuildContext context) async {
    await launch(kDefaultAliasURL).catchError((error, stackTrace) {
      throw Fluttertoast.showToast(
        msg: error.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
      );
    });
  }

  Future buildAddNewRecipient(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddNewRecipient(),
    );
  }

  Future buildAddNewUsername(BuildContext context) {
    final usernameManager = context.read(usernameStateManagerProvider);
    final createNewUsername = usernameManager.createNewUsername;
    final usernameFormKey = usernameManager.usernameFormKey;

    final textEditController = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final size = MediaQuery.of(context).size;

        void createUsername() {
          createNewUsername(
              context, textEditController.text.trim(), textEditController);
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
          child: Column(
            children: [
              Divider(
                thickness: 3,
                indent: size.width * 0.4,
                endIndent: size.width * 0.4,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'Add new username',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(thickness: 1),
              SizedBox(height: size.height * 0.01),
              Text(kAddNewUsernameText),
              SizedBox(height: size.height * 0.02),
              Form(
                key: usernameFormKey,
                child: TextFormField(
                  autofocus: true,
                  controller: textEditController,
                  validator: (input) =>
                      FormValidator().validateUsernameInput(input),
                  onFieldSubmitted: (toggle) => createUsername(),
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: 'johndoe',
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              RaisedButton(
                child: Text('Update'),
                onPressed: () => createUsername(),
              ),
            ],
          ),
        );
      },
    );
  }
}
