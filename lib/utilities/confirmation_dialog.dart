import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog {
  Widget androidAlertDialog(context, String content, Function method,
      [String title, String yesButton, String noButton]) {
    return AlertDialog(
      title: title == null ? null : Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(yesButton == null ? 'Yes' : yesButton),
          onPressed: () => method(),
        ),
        TextButton(
          child: Text(noButton == null ? 'No' : noButton),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Widget iOSAlertDialog(context, String content, Function method,
      [String title, String yesButton, String noButton]) {
    return CupertinoAlertDialog(
      title: title == null ? null : Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: Text(yesButton == null ? 'Yes' : yesButton),
          onPressed: () => method(),
        ),
        CupertinoDialogAction(
          child: Text(noButton == null ? 'No' : noButton),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
