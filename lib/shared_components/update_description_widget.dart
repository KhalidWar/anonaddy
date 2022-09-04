import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_input_field.dart';
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
  final formKey = GlobalKey<FormState>();
  String newDescription = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHeader(
              headerLabel: AppStrings.updateDescriptionTitle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(AppStrings.updateDescriptionString),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: formKey,
                  child: PlatformInputField(
                    placeholder: widget.description ?? 'No description',
                    onChanged: (input) => newDescription = input,
                    onFieldSubmitted: (input) {
                      if (formKey.currentState!.validate()) {
                        widget.updateDescription(newDescription);
                        if (mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
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
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: PlatformButton(
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            widget.updateDescription(newDescription);
                            if (mounted) Navigator.pop(context);
                          }
                        },
                        color: AppColors.accentColor,
                        child: const Text(
                          AppStrings.updateDescriptionTitle,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
