import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRecipient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipientManager = context.read(recipientStateManagerProvider);
    final recipientFormKey = recipientManager.recipientFormKey;
    final textEditController = recipientManager.textEditController;
    final addRecipient = recipientManager.addRecipient;
    final isLoading = recipientManager.isLoading;

    final size = MediaQuery.of(context).size;

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(headerLabel: 'Add New Recipient'),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Column(
              children: [
                Text(kAddRecipientString),
                SizedBox(height: size.height * 0.02),
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
                SizedBox(height: size.height * 0.02),
                isLoading
                    ? CustomLoadingIndicator().customLoadingIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom().copyWith(
                          minimumSize: MaterialStateProperty.all(Size(200, 50)),
                        ),
                        child: Text('Add Recipient'),
                        onPressed: () => addRecipient(
                            context, textEditController.text.trim()),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
