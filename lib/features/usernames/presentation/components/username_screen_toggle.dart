import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_switch.dart';
import 'package:flutter/material.dart';

class UsernameScreenToggle extends StatelessWidget {
  const UsernameScreenToggle({
    super.key,
    required this.isLoading,
    required this.value,
  });

  final bool isLoading;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLoading ? const PlatformLoadingIndicator(size: 20) : Container(),
        PlatformSwitch(
          value: value,
          onChanged: (toggle) {},
        ),
      ],
    );
  }
}
