import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:flutter/material.dart';

class RecipientScreenTrailingLoadingSwitch extends StatelessWidget {
  const RecipientScreenTrailingLoadingSwitch({
    Key? key,
    required this.isLoading,
    required this.switchValue,
    this.onPress,
  }) : super(key: key);
  final bool isLoading;
  final bool switchValue;
  final Function(bool)? onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLoading ? const PlatformLoadingIndicator(size: 15) : Container(),
        PlatformSwitch(
          value: switchValue,
          onChanged: onPress,
        ),
      ],
    );
  }
}
