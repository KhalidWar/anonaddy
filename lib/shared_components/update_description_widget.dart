import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';

class UpdateDescriptionWidget extends StatefulWidget {
  const UpdateDescriptionWidget({
    Key? key,
    required this.description,
    required this.updateDescription,
    required this.removeDescription,
  }) : super(key: key);

  final String? description;
  final Function(String) updateDescription;
  final Function removeDescription;

  @override
  State createState() => _UpdateDescriptionWidgetState();
}

class _UpdateDescriptionWidgetState extends State<UpdateDescriptionWidget> {
  final textEditController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void addRecipient() {
    if (formKey.currentState!.validate()) {
      widget.updateDescription(textEditController.text.trim());
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(AppStrings.updateDescriptionString),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              controller: textEditController,
              textInputAction: TextInputAction.done,
              validator: FormValidator.requiredField,
              onFieldSubmitted: (input) => addRecipient(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                    (widget.description == null || widget.description!.isEmpty)
                        ? 'No description'
                        : widget.description,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PlatformButton(
                  color: Colors.redAccent,
                  onPress: () {
                    widget.removeDescription();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text(
                    AppStrings.removeDescriptionTitle,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PlatformButton(
                  onPress: () => addRecipient(),
                  color: AppColors.accentColor,
                  child: const Text(
                    AppStrings.updateDescriptionTitle,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
