import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDescriptionInputField extends PlatformAware {
  const PlatformDescriptionInputField({
    this.onChanged,
    this.onFieldSubmitted,
    this.placeholder,
  });
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? placeholder;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoTextField(
      autofocus: true,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted,
      placeholder: placeholder,
      decoration: BoxDecoration(
        border: Border.all(color: kAccentColor),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: placeholder,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kAccentColor),
        ),
      ),
    );
  }
}
