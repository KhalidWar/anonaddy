import 'package:anonaddy/common/form_validator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/features/create_alias/presentation/components/create_alias_error_widget.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRuleEnterName extends ConsumerStatefulWidget {
  const AddNewRuleEnterName({
    super.key,
    required this.ruleId,
    required this.onPress,
  });

  final String ruleId;
  final Function(String) onPress;

  @override
  ConsumerState createState() => _AddNewRuleEnterNameState();
}

class _AddNewRuleEnterNameState extends ConsumerState<AddNewRuleEnterName> {
  final _textEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addNewRule() async {
    if (_formKey.currentState!.validate()) {
      widget.onPress(_textEditController.text.trim());
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
                  autocorrect: false,
                  controller: _textEditController,
                  textInputAction: TextInputAction.done,
                  validator: FormValidator.requiredField,
                  maxLength: 50,
                  onFieldSubmitted: (input) => addNewRule(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: createAliasState.ruleName ?? 'Enter Name',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PlatformButton(
                  onPress: () async => await addNewRule(),
                  child: Text(
                    'Add Name',
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
      },
      error: (error, _) => CreateAliasErrorWidget(message: error.toString()),
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
