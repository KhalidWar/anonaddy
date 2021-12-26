import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_notifier.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _textEditController,
                    validator: (input) =>
                        FormValidator.validateEmailField(input!),
                    textInputAction: TextInputAction.next,
                    decoration: kTextFormFieldDecoration.copyWith(
                        hintText: 'joedoe@example.com'),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Consumer(
                  builder: (context, watch, _) {
                    final recipientState = watch(recipientScreenStateNotifier);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom().copyWith(
                        minimumSize: MaterialStateProperty.all(Size(200, 50)),
                      ),
                      child: recipientState.isAddRecipientLoading!
                          ? PlatformLoadingIndicator()
                          : Text('Add Recipient'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await context
                              .read(recipientScreenStateNotifier.notifier)
                              .addRecipient(_textEditController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
