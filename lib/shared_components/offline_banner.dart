import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_info_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants/ui_strings.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({Key? key}) : super(key: key);

  void _onPress(BuildContext context) {
    if (PlatformAware.isIOS()) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return PlatformInfoDialog(
            title: kNoInternetDialogTitle,
            content: Text(kNoInternetContent),
            buttonLabel: kNoInternetDialogButton,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return PlatformInfoDialog(
            title: kNoInternetDialogTitle,
            content: Text(kNoInternetContent),
            buttonLabel: kNoInternetDialogButton,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.red,
      title: Text(kNoInternetOfflineData),
      leading: Icon(Icons.warning_amber_outlined),
      onTap: () => _onPress(context),
    );
  }
}
