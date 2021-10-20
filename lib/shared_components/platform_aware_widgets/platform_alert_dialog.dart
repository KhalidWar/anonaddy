import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends PlatformAware {
  PlatformAlertDialog({
    required this.content,
    required this.method,
    this.title,
    this.approveButton,
    this.cancelButton,
  });

  final String content;
  final Function method;
  final String? title, approveButton, cancelButton;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: title == null ? null : Text(title!),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: Text(cancelButton == null ? 'Cancel' : cancelButton!),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          isDefaultAction: true,
          child: Text(approveButton == null ? 'Yes' : approveButton!),
          onPressed: () => method(),
        ),
      ],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title!),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(cancelButton == null ? 'Cancel' : cancelButton!),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(approveButton == null ? 'Yes' : approveButton!),
          onPressed: () => method(),
        ),
      ],
    );
  }
}
