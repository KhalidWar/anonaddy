import 'package:anonaddy/features/recipients/presentation/controller/add_recipient_notifier.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRecipient extends ConsumerStatefulWidget {
  const AddNewRecipient({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AddNewRecipientState();
}

class _AddNewRecipientState extends ConsumerState<AddNewRecipient> {
  final _textEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addRecipient() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(addRecipientNotifierProvider.notifier)
          .addRecipient(_textEditController.text.trim());
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(AddyString.addRecipientString),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: _textEditController,
              textInputAction: TextInputAction.done,
              validator: FormValidator.validateEmailField,
              onFieldSubmitted: (input) => addRecipient(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'joedoe@example.com',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              onPress: () async => await addRecipient(),
              child: Consumer(
                builder: (context, ref, _) {
                  final addRecipientAsync =
                      ref.watch(addRecipientNotifierProvider);

                  return addRecipientAsync.when(
                    data: (data) {
                      return Text(
                        'Add Recipient',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.black),
                      );
                    },
                    error: (err, stack) => const PlatformLoadingIndicator(),
                    loading: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
