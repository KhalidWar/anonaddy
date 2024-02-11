import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientAddPgpKey extends ConsumerStatefulWidget {
  const RecipientAddPgpKey({
    required this.recipient,
    Key? key,
  }) : super(key: key);

  final Recipient recipient;

  @override
  ConsumerState createState() => _RecipientAddPgpKeyState();
}

class _RecipientAddPgpKeyState extends ConsumerState<RecipientAddPgpKey> {
  final formKey = GlobalKey<FormState>();
  String keyData = '';

  Future<void> addPublicKey() async {
    if (formKey.currentState!.validate()) {
      await ref
          .read(recipientScreenStateNotifier.notifier)
          .addPublicGPGKey(keyData);
      if (mounted) Navigator.pop(context);
    }
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
          const BottomSheetHeader(headerLabel: 'Add GPG Key'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Text(AppStrings.addPublicKeyNote),
                SizedBox(height: size.height * 0.015),
                Form(
                  key: formKey,
                  child: TextFormField(
                    autofocus: true,
                    validator: (input) =>
                        FormValidator.validatePGPKeyField(input!),
                    minLines: 4,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    onChanged: (input) => keyData = input,
                    onFieldSubmitted: (submit) => addPublicKey(),
                    decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                      contentPadding: const EdgeInsets.all(5),
                      hintText: AppStrings.publicKeyFieldHint,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  child: const Text('Add Key'),
                  onPressed: () => addPublicKey(),
                ),
                SizedBox(height: size.height * 0.015),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
