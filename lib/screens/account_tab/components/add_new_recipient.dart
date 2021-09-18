import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';

class AddNewRecipient extends StatefulWidget {
  @override
  State<AddNewRecipient> createState() => _AddNewRecipientState();
}

class _AddNewRecipientState extends State<AddNewRecipient> {
  final _textEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _textEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipientManager = context.read(recipientStateManagerProvider);
    final size = MediaQuery.of(context).size;

    Future<void> addRecipient() async {
      if (_formKey.currentState!.validate()) {
        await recipientManager.addRecipient(
            context, _textEditController.text.trim());
      }
    }

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
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _textEditController,
                    validator: (input) =>
                        context.read(formValidator).validateEmailField(input!),
                    textInputAction: TextInputAction.next,
                    decoration: kTextFormFieldDecoration.copyWith(
                        hintText: 'joedoe@example.com'),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                recipientManager.isLoading
                    ? context
                        .read(customLoadingIndicator)
                        .customLoadingIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom().copyWith(
                          minimumSize: MaterialStateProperty.all(Size(200, 50)),
                        ),
                        child: Text('Add Recipient'),
                        onPressed: () => addRecipient(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
