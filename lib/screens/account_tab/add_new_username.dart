import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class AddNewUsername extends StatelessWidget {
  final _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usernameManager = context.read(usernameStateManagerProvider);
    final createNewUsername = usernameManager.createNewUsername;
    final usernameFormKey = usernameManager.createUsernameFormKey;

    final size = MediaQuery.of(context).size;

    void createUsername() {
      createNewUsername(context, _textEditController.text.trim());
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
              controller: _textEditController,
              validator: (input) =>
                  FormValidator().validateUsernameInput(input),
              onFieldSubmitted: (toggle) => createUsername(),
              decoration: kTextFormFieldDecoration.copyWith(
                hintText: 'johndoe',
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          ElevatedButton(
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: MaterialStateProperty.all(Size(200, 50)),
            ),
            child: Text('Add Username'),
            onPressed: () => createUsername(),
          ),
        ],
      ),
    );
  }
}
