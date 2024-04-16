import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/form_validator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:flutter/material.dart';

class SendFromWidget extends StatefulWidget {
  const SendFromWidget({
    super.key,
    required this.email,
    required this.onSubmitted,
  });

  final String email;
  final Function(String) onSubmitted;

  @override
  State<SendFromWidget> createState() => _SendFromWidgetState();
}

class _SendFromWidgetState extends State<SendFromWidget> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.email,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              validator: FormValidator.validateEmailField,
              controller: controller,
              onFieldSubmitted: widget.onSubmitted,
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              child: const Text(
                'Generate address',
                style: TextStyle(color: Colors.black),
              ),
              onPress: () {
                if (formKey.currentState!.validate()) {
                  widget.onSubmitted(controller.text.trim());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
