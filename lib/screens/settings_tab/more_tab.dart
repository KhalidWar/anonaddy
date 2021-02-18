import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/screens/settings_tab/app_settings.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

final recipientStreamProvider =
    StreamProvider.autoDispose<RecipientModel>((ref) async* {
  yield* Stream.fromFuture(
      ref.read(recipientServiceProvider).getAllRecipient());
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield* Stream.fromFuture(
        ref.read(recipientServiceProvider).getAllRecipient());
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
                      accountStream.when(
                        loading: () => Container(),
                        data: (data) => Text(
                            '${data.recipientCount} / ${NicheMethod().isUnlimited(data.recipientLimit, '')}'),
                        error: (error, stackTrace) => Text(''),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        onPressed: () => buildShowModalBottomSheet(context),
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
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionsBuilder:
                    (context, animation, secondAnimation, child) {
                  animation = CurvedAnimation(
                      parent: animation, curve: Curves.linearToEaseOut);

                  return SlideTransition(
                    position: Tween(
                      begin: Offset(1.0, 0.0),
                      end: Offset(0.0, 0.0),
                    ).animate(animation),
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondAnimation) {
                  return AppSettings();
                },
              ),
            ),
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
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final recipientManager = context.read(recipientStateManagerProvider);

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
                    key: recipientManager.recipientFormKey,
                    child: TextFormField(
                      autofocus: true,
                      controller: recipientManager.textEditController,
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
                    onPressed: () {
                      recipientManager.addRecipient(
                        context,
                        recipientManager.textEditController.text.trim(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
