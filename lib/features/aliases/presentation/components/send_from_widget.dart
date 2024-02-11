import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';

class SendFromWidget extends StatelessWidget {
  const SendFromWidget({
    Key? key,
    required this.email,
    required this.formKey,
    required this.onFieldSubmitted,
  }) : super(key: key);

  final String email;
  final GlobalKey<FormState> formKey;
  final Function(String) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          const Text('Email destination'),
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              validator: (input) => FormValidator.validateEmailField(input!),
              onFieldSubmitted: onFieldSubmitted,
              decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                hintText: 'Enter email...',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.sendFromAliasNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
