import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/screens/account_tab/username_detailed_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/state_management/username_state_manager.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/custom_page_route.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final additionalUsernameStreamProvider =
    StreamProvider.autoDispose<UsernameModel>((ref) async* {
  final offlineData = ref.read(offlineDataProvider);
  yield* Stream.fromFuture(
      ref.read(usernameServiceProvider).getUsernameData(offlineData));
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield* Stream.fromFuture(
        ref.read(usernameServiceProvider).getUsernameData(offlineData));
  }
});

class AdditionalUsername extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final additionalUsernameStream = watch(additionalUsernameStreamProvider);
    final userModel = watch(accountStreamProvider);
    final usernameStateManager = watch(usernameStateManagerProvider);
    final showToast = usernameStateManager.showToast;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return additionalUsernameStream.when(
      loading: () => Container(),
      data: (usernameData) {
        return userModel.when(
          loading: () => Container(),
          data: (userModelData) {
            final isFree = userModelData.subscription == 'free';
            final usernameCount = userModelData.usernameCount;
            final usernameLimit = userModelData.usernameLimit;

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
                        'Username${usernameData.usernameDataList.length >= 2 ? 's' : ''}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      isFree
                          ? Text('0 / 0')
                          : Text(
                              '$usernameCount / ${NicheMethod().isUnlimited(usernameLimit, '')}'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        onPressed: isFree
                            ? () => showToast(kOnlyAvailableToPaid)
                            : () => usernameCount == usernameLimit
                                ? showToast(kReachedUsernameLimit)
                                : buildAddNewUsername(
                                    context, usernameStateManager),
                      ),
                    ],
                  ),
                ),
                if (usernameData.usernameDataList.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: isFree
                        ? Text(
                            'Additional Usernames only available to paid users',
                          )
                        : Text('No additional usernames found'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: usernameData.usernameDataList.length,
                    itemBuilder: (context, index) {
                      final username = usernameData.usernameDataList[index];

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
                            CustomPageRoute(
                                UsernameDetailedScreen(username: username)),
                          );
                        },
                      );
                    },
                  ),
              ],
            );
          },
          error: (error, stackTrace) => Text('Error'),
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
                key: usernameStateManager.usernameFormKey,
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
