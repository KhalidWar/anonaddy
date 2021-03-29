import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class AddNewRecipient extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final recipientManager = watch(recipientStateManagerProvider);
    final recipientFormKey = recipientManager.recipientFormKey;
    final textEditController = recipientManager.textEditController;
    final addRecipient = recipientManager.addRecipient;
    final isLoading = recipientManager.isLoading;

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
              isLoading
                  ? CustomLoadingIndicator().customLoadingIndicator()
                  : RaisedButton(
                      child: Text('Add Recipient'),
                      onPressed: () =>
                          addRecipient(context, textEditController.text.trim()),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
