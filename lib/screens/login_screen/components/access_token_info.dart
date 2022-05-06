import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class AccessTokenInfo extends StatelessWidget {
  const AccessTokenInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('accessTokenInfoSheetColumn'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BottomSheetHeader(headerLabel: AppStrings.whatsAccessToken),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.whatsAccessToken,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 5),
              const Text(AppStrings.accessTokenDefinition),
              const SizedBox(height: 20),
              Text(
                AppStrings.accessTokenRequired,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.howToGetAccessToken,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 5),
              const Text(AppStrings.howToGetAccessToken1),
              const Text(AppStrings.howToGetAccessToken2),
              const Text(AppStrings.howToGetAccessToken3),
              const Text(AppStrings.howToGetAccessToken4),
              const Text(AppStrings.howToGetAccessToken5),
              const SizedBox(height: 20),
              Text(
                AppStrings.accessTokenSecurityNotice,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(AppStrings.getAccessToken),
              SizedBox(width: 4),
              Icon(Icons.open_in_new_outlined),
            ],
          ),
          onPressed: () => NicheMethod.launchURL(kAnonAddySettingsURL),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
