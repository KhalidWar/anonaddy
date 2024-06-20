import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/form_validator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewUsername extends ConsumerStatefulWidget {
  const AddNewUsername({super.key});

  @override
  ConsumerState createState() => _AddNewUserNameState();
}

class _AddNewUserNameState extends ConsumerState<AddNewUsername> {
  final _textEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> createUsername() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(usernamesNotifierProvider.notifier)
          .addNewUsername(_textEditController.text.trim());
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
          const Text(AddyString.addNewUsernameString),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: _textEditController,
              validator: FormValidator.requiredField,
              onFieldSubmitted: (toggle) => createUsername(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'johndoe',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              onPress: () => createUsername(),
              child: Text(
                AppStrings.addUsername,
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
