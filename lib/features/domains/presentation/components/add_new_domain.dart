import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewDomain extends ConsumerStatefulWidget {
  const AddNewDomain({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AddNewDomainState();
}

class _AddNewDomainState extends ConsumerState<AddNewDomain> {
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
          const BottomSheetHeader(headerLabel: 'Add New Recipient'),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Column(
              children: [
                const Text(AddyString.addRecipientString),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _textEditController,
                    validator: (input) =>
                        FormValidator.validateEmailField(input!),
                    textInputAction: TextInputAction.next,
                    decoration: AppTheme.kTextFormFieldDecoration
                        .copyWith(hintText: 'joedoe@example.com'),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Consumer(
                  builder: (context, watch, _) {
                    final recipientState =
                        ref.watch(recipientScreenStateNotifier);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom().copyWith(
                        minimumSize: MaterialStateProperty.all(
                          const Size(200, 50),
                        ),
                      ),
                      child: recipientState.isAddRecipientLoading
                          ? const PlatformLoadingIndicator()
                          : const Text('Add Recipient'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(recipientScreenStateNotifier.notifier)
                              .addRecipient(_textEditController.text.trim());
                          if (mounted) Navigator.pop(context);
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
