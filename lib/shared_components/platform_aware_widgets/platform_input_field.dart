import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformInputField extends PlatformAware {
  const PlatformInputField({
    super.key,
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
        border: Border.all(color: AppColors.accentColor),
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
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
      ),
    );
  }
}
