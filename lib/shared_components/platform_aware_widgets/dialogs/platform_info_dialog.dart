import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform_aware.dart';

class PlatformInfoDialog extends PlatformAware {
  const PlatformInfoDialog({
    required this.title,
    required this.buttonLabel,
    required this.content,
  });
  final String title, buttonLabel;
  final Widget content;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: content,
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
