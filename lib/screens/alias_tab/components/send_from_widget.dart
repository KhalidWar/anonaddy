import 'package:anonaddy/notifiers/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendFromWidget extends ConsumerStatefulWidget {
  const SendFromWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SendFromWidgetState();
}

class _SendFromWidgetState extends ConsumerState<SendFromWidget> {
  final sendFromFormKey = GlobalKey<FormState>();
  String destinationEmail = '';

  Future<void> generateAddress(String email) async {
    if (sendFromFormKey.currentState!.validate()) {
      await ref
          .read(aliasScreenStateNotifier.notifier)
          .sendFromAlias(email, destinationEmail);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alias = ref.read(aliasScreenStateNotifier).alias;

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHeader(
            headerLabel: AppStrings.sendFromAlias,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.sendFromAliasString),
                SizedBox(height: size.height * 0.01),
                TextFormField(
                  enabled: false,
                  decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                    hintText: alias.email,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Email destination',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: size.height * 0.01),
                Form(
                  key: sendFromFormKey,
                  child: TextFormField(
                    autofocus: true,
                    validator: (input) =>
                        FormValidator.validateEmailField(input!),
                    onChanged: (input) => destinationEmail = input,
                    onFieldSubmitted: (toggle) => generateAddress(alias.email),
                    decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                      hintText: 'Enter email...',
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  AppStrings.sendFromAliasNote,
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Generate address'),
                    onPressed: () => generateAddress(alias.email),
                  ),
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
