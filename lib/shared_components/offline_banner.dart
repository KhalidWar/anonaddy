import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_info_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.redAccent,
      iconColor: Colors.black,
      minLeadingWidth: 0,
      title: const Text(AppStrings.noInternetOfflineData),
      leading: const Icon(Icons.warning_amber_outlined),
      onTap: () {
        PlatformAware.platformDialog(
          context: context,
          child: const PlatformInfoDialog(
            title: AppStrings.noInternetDialogTitle,
            content: Text(AppStrings.noInternetContent),
            buttonLabel: AppStrings.noInternetDialogButton,
          ),
        );
      },
    );
  }
}
