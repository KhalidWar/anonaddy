import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global_providers.dart';
import 'bottom_sheet_header.dart';
import 'constants/material_constants.dart';
import 'constants/ui_strings.dart';

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
                SizedBox(height: size.height * 0.015),
                Form(
                  key: descriptionFormKey,
                  child: TextFormField(
                    autofocus: true,
                    validator: (input) => context
                        .read(formValidator)
                        .validateDescriptionField(input!),
                    onChanged: inputOnChanged,
                    onFieldSubmitted: (toggle) => updateDescription(),
                    decoration: kTextFormFieldDecoration.copyWith(
                      hintText: description ?? 'No description',
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          minimumSize: Size(120, size.height * 0.055),
                        ),
                        child: Text(kRemoveDescription),
                        onPressed: removeDescription,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, size.height * 0.055),
                        ),
                        child: Text(kUpdateDescription),
                        onPressed: updateDescription,
                      ),
                    ),
                  ],
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
