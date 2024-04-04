import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/create_alias/presentation/components/create_alias_error_widget.dart';
import 'package:anonaddy/features/recipients/presentation/controller/add_recipient_notifier.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRuleEnterName extends ConsumerStatefulWidget {
  const AddNewRuleEnterName({
    super.key,
    required this.ruleId,
  });

  final String ruleId;

  @override
  ConsumerState createState() => _AddNewRuleEnterNameState();
}

class _AddNewRuleEnterNameState extends ConsumerState<AddNewRuleEnterName> {
  final _textEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addNewRule() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(addRecipientNotifierProvider.notifier)
          .addRecipient(_textEditController.text.trim());
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
    final ruleAsync = ref.watch(createNewRuleNotifierProvider(widget.ruleId));

    return ruleAsync.when(
      data: (createAliasState) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: _textEditController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.validateEmailField,
                  onFieldSubmitted: (input) => addNewRule(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PlatformButton(
                  onPress: () async => await addNewRule(),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final addRecipientAsync =
                          ref.watch(addRecipientNotifierProvider);

                      return addRecipientAsync.when(
                        data: (data) {
                          return Text(
                            'Add Name',
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
      },
      error: (error, _) {
        return CreateAliasErrorWidget(message: error.toString());
      },
      loading: () => SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        width: double.infinity,
        child: const Center(
          child: PlatformLoadingIndicator(),
        ),
      ),
    );
  }
}
