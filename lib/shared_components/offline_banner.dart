import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_info_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.red,
      title: const Text(kNoInternetOfflineData),
      leading: const Icon(Icons.warning_amber_outlined),
      onTap: () {
        PlatformAware.platformDialog(
          context: context,
          child: const PlatformInfoDialog(
            title: kNoInternetDialogTitle,
            content: Text(kNoInternetContent),
            buttonLabel: kNoInternetDialogButton,
          ),
        );
      },
    );
  }
}
