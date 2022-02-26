import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformInfoDialog extends PlatformAware {
  const PlatformInfoDialog({
    Key? key,
    required this.title,
    required this.buttonLabel,
    required this.content,
  }) : super(key: key);
  final String title, buttonLabel;
  final Widget content;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Material(
        color: Colors.transparent,
        child: content,
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          isDefaultAction: true,
          child: Text(buttonLabel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          child: Text(buttonLabel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
