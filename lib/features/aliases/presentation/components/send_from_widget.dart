import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';

class SendFromWidget extends StatelessWidget {
  const SendFromWidget({
    super.key,
    required this.email,
    required this.formKey,
    required this.onFieldSubmitted,
  });

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
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              validator: FormValidator.validateEmailField,
              onFieldSubmitted: onFieldSubmitted,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Destination Email Address',
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
