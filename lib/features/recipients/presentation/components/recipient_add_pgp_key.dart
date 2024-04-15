import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/form_validator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientAddPgpKey extends ConsumerStatefulWidget {
  const RecipientAddPgpKey({
    required this.recipient,
    super.key,
  });

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
          .read(recipientScreenNotifierProvider(widget.recipient.id).notifier)
          .addPublicGPGKey(keyData);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(AppStrings.addPublicKeyNote),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              validator: FormValidator.requiredField,
              minLines: 4,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              onChanged: (input) => keyData = input,
              onFieldSubmitted: (submit) => addPublicKey(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: AppStrings.publicKeyFieldHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              onPress: () => addPublicKey(),
              child: Text(
                'Add PGP Key',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
