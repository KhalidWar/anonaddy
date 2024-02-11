import 'package:anonaddy/features/usernames/presentation/controller/usernames_screen_notifier.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewUsername extends ConsumerStatefulWidget {
  const AddNewUsername({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AddNewUserNameState();
}

class _AddNewUserNameState extends ConsumerState<AddNewUsername> {
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

    Future<void> createUsername() async {
      if (_formKey.currentState!.validate()) {
        await ref
            .read(usernamesScreenStateNotifier.notifier)
            .addNewUsername(_textEditController.text.trim());
        if (mounted) Navigator.pop(context);
      }
    }

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHeader(
            headerLabel: AppStrings.addNewUsername,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Column(
              children: [
                const Text(AnonAddyString.addNewUsernameString),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _textEditController,
                    validator: (input) =>
                        FormValidator.validateUsernameInput(input!),
                    onFieldSubmitted: (toggle) => createUsername(),
                    decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                      hintText: 'johndoe',
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                ElevatedButton(
                  style: ElevatedButton.styleFrom().copyWith(
                    minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  ),
                  child: const Text(AppStrings.addUsername),
                  onPressed: () => createUsername(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
