import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_switch.dart';
import 'package:flutter/material.dart';

class RecipientScreenTrailingLoadingSwitch extends StatelessWidget {
  const RecipientScreenTrailingLoadingSwitch({
    super.key,
    required this.isLoading,
    required this.switchValue,
    this.onPress,
  });

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
