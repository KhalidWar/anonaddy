import 'package:animations/animations.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/services/theme/theme_service.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

final recipientDataStream =
    StreamProvider.autoDispose<RecipientModel>((ref) async* {
  yield* Stream.fromFuture(
      ref.read(recipientServiceProvider).getAllRecipient());
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield* Stream.fromFuture(
        ref.read(recipientServiceProvider).getAllRecipient());
  }
});

class SettingsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final recipientData = watch(recipientDataStream);
    final userModel = watch(mainAccountStream);

    final recipientStateProvider = context.read(recipientStateManagerProvider);
    final addRecipient = recipientStateProvider.addRecipient;
    final textEditController = recipientStateProvider.textEditController;
    final recipientFormKey = recipientStateProvider.recipientFormKey;

    return SingleChildScrollView(
      padding: EdgeInsets.all(size.height * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // todo implement feedback mechanism.
          // todo Give dev email to receive feedback and suggestions
          // todo encourage users to get into beta program

          recipientData.when(
            loading: () => LoadingIndicator(),
            data: (data) {
              final recipientList = data.recipientDataList;
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
                      userModel.when(
                        loading: () => Container(),
                        data: (data) => Text(
                            '${data.recipientCount} / ${NicheMethod().isUnlimited(data.recipientLimit, '')}'),
                        error: (error, stackTrace) => Text(''),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        onPressed: () => buildShowModalBottomSheet(context,
                            textEditController, recipientFormKey, addRecipient),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
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
            error: (error, stackTrace) {
              return LottieWidget(
                showLoading: true,
                lottie: 'assets/lottie/errorCone.json',
                label: '$error',
              );
            },
          ),
          Divider(height: 0),
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              'App Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            children: [
              ListTile(
                leading: Text(
                  'Dark Theme',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                trailing: Switch.adaptive(
                  value: context.read(themeServiceProvider).isDarkTheme,
                  onChanged: (toggle) =>
                      context.read(themeServiceProvider).toggleTheme(),
                ),
              ),
              ListTile(
                leading: Text(
                  'About App',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () => aboutAppDialog(context),
              ),
              SizedBox(height: size.height * 0.01),
              ListTile(
                tileColor: Colors.red,
                title: Center(
                  child: Text(
                    'Log Out',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                onTap: () => buildLogoutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future buildShowModalBottomSheet(
      BuildContext context,
      TextEditingController textEditController,
      GlobalKey recipientFormKey,
      Function addRecipient) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Divider(
                  thickness: 3,
                  indent: size.width * 0.4,
                  endIndent: size.width * 0.4,
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Add new recipient',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(thickness: 1),
                SizedBox(height: size.height * 0.01),
                Column(
                  children: [
                    Text(kAddRecipientText),
                    SizedBox(height: size.height * 0.01),
                    Form(
                      key: recipientFormKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditController,
                        validator: (input) =>
                            FormValidator().validateRecipientEmail(input),
                        textInputAction: TextInputAction.next,
                        decoration: kTextFormFieldDecoration.copyWith(
                            hintText: 'joedoe@example.com'),
                      ),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text('Add Recipient'),
                      onPressed: () => addRecipient(
                        context,
                        textEditController.text.trim(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future buildLogoutDialog(BuildContext context) {
    final logout = context.read(loginStateManagerProvider).logout;
    final confirmationDialog = ConfirmationDialog();

    return showModal(
      context: context,
      builder: (context) {
        signOut() {
          logout(context).then((value) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TokenLoginScreen();
                },
              ),
            );
          });
        }

        return TargetedPlatform().isIOS()
            ? confirmationDialog.iOSAlertDialog(
                context, kSignOutAlertDialog, signOut, 'Sign out')
            : confirmationDialog.androidAlertDialog(
                context, kSignOutAlertDialog, signOut, 'Sign out');
      },
    );
  }

  aboutAppDialog(BuildContext context) async {
    final confirmationDialog = ConfirmationDialog();

    launchUrl() async {
      await launch(kGithubRepoURL).catchError((error, stackTrace) {
        throw Fluttertoast.showToast(
          msg: error.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[600],
        );
      });
      Navigator.pop(context);
    }

    showModal(
      context: context,
      builder: (context) {
        return TargetedPlatform().isIOS()
            ? confirmationDialog.iOSAlertDialog(context, kAboutAppText,
                launchUrl, 'About App', 'Visit Github', 'Cancel')
            : confirmationDialog.androidAlertDialog(context, kAboutAppText,
                launchUrl, 'About App', 'Visit Github', 'Cancel');
      },
    );
  }
}
