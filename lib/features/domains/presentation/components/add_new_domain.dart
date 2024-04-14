import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/domains/presentation/controller/add_domain_notifier.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewDomain extends ConsumerStatefulWidget {
  const AddNewDomain({super.key});

  @override
  ConsumerState createState() => _AddNewDomainState();
}

class _AddNewDomainState extends ConsumerState<AddNewDomain> {
  final _textEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addNewDomain() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(addDomainNotifierProvider.notifier)
          .addDomain(_textEditController.text.trim());
      await ref.read(accountNotifierProvider.notifier).fetchAccount();
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
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: _textEditController,
              validator: (input) => FormValidator.validateEmailField(input!),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (input) => addNewDomain(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'example.com',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              onPress: addNewDomain,
              child: Consumer(
                builder: (context, ref, _) {
                  final addRecipientAsync =
                      ref.watch(addDomainNotifierProvider);

                  return addRecipientAsync.when(
                    data: (data) {
                      return Text(
                        'Add Domain',
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
