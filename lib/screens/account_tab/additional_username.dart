import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/screens/account_tab/username_detailed_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/username_state_manager.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final additionalUsernameStreamProvider =
    StreamProvider.autoDispose<UsernameModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(usernameServiceProvider).getUsernameData());
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield* Stream.fromFuture(
        ref.read(usernameServiceProvider).getUsernameData());
  }
});

class AdditionalUsername extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final additionalUsernameStream = watch(additionalUsernameStreamProvider);
    final userModel = watch(accountStreamProvider);
    final usernameStateManager = watch(usernameStateManagerProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return additionalUsernameStream.when(
      loading: () => Container(),
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Username${data.usernameDataList.length >= 2 ? 's' : ''}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  userModel.when(
                    loading: () => Container(),
                    data: (data) => Text(
                        '${data.usernameCount} / ${NicheMethod().isUnlimited(data.usernameLimit, '')}'),
                    error: (error, stackTrace) => Text('Error'),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_outlined),
                    onPressed: () =>
                        buildAddNewUsername(context, usernameStateManager),
                  ),
                ],
              ),
            ),
            if (data.usernameDataList.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Text('No additional usernames found'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.usernameDataList.length,
                itemBuilder: (context, index) {
                  final username = data.usernameDataList[index];

                  return InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            color: isDark ? Colors.white : Colors.grey,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username.username),
                              SizedBox(height: 2),
                              Text(
                                username.description ?? 'No description',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionsBuilder:
                              (context, animation, secondAnimation, child) {
                            animation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.linearToEaseOut);

                            return SlideTransition(
                              position: Tween(
                                begin: Offset(1.0, 0.0),
                                end: Offset(0.0, 0.0),
                              ).animate(animation),
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, secondAnimation) {
                            return UsernameDetailedScreen(username: username);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: '$error',
        );
      },
    );
  }

  Future buildAddNewUsername(
      BuildContext context, UsernameStateManager usernameStateManager) {
    final createNewUsername = usernameStateManager.createNewUsername;
    final textEditController = TextEditingController();

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
                key: usernameStateManager.usernameFormKey,
                child: TextFormField(
                  autofocus: true,
                  controller: textEditController,
                  validator: (input) =>
                      FormValidator().validateUsernameInput(input),
                  onFieldSubmitted: (toggle) => createNewUsername(context,
                      textEditController.text.trim(), textEditController),
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: 'johndoe',
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              RaisedButton(
                child: Text('Update'),
                onPressed: () => createNewUsername(context,
                    textEditController.text.trim(), textEditController),
              ),
            ],
          ),
        );
      },
    );
  }
}
