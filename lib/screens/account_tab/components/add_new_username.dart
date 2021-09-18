import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';

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

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(headerLabel: 'Add New Username'),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Column(
              children: [
                Text(kAddNewUsernameString),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: usernameFormKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _textEditController,
                    validator: (input) => context
                        .read(formValidator)
                        .validateUsernameInput(input!),
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
          ),
        ],
      ),
    );
  }
}
