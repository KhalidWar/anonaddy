import 'package:anonaddy/shared_components/platform_aware_widgets/platform_description_input_field.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_header.dart';
import 'constants/ui_strings.dart';
import 'platform_aware_widgets/platform_button.dart';

class UpdateDescriptionWidget extends StatelessWidget {
  const UpdateDescriptionWidget({
    Key? key,
    required this.description,
    required this.descriptionFormKey,
    required this.inputOnChanged,
    required this.updateDescription,
    required this.removeDescription,
  }) : super(key: key);

  final String? description;
  final GlobalKey descriptionFormKey;
  final Function(String)? inputOnChanged;
  final Function() updateDescription;
  final Function() removeDescription;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(headerLabel: kUpdateDescription),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(kUpdateDescriptionString),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: descriptionFormKey,
                  child: PlatformDescriptionInputField(
                    placeholder: description ?? 'No description',
                    onChanged: inputOnChanged,
                    onFieldSubmitted: (toggle) => updateDescription(),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PlatformButton(
                        color: Colors.redAccent,
                        labelColor: Colors.black,
                        label: kRemoveDescription,
                        onPress: removeDescription,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: PlatformButton(
                        labelColor: Colors.black,
                        label: kUpdateDescription,
                        onPress: updateDescription,
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
