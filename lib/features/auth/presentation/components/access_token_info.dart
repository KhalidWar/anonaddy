import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AccessTokenInfo extends StatelessWidget {
  const AccessTokenInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('accessTokenInfoSheetColumn'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.accessTokenDefinition),
          const SizedBox(height: 16),
          Text(
            AppStrings.accessTokenRequired,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.howToGetAccessToken,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          const Text(AppStrings.howToGetAccessToken1),
          const Text(AppStrings.howToGetAccessToken2),
          const Text(AppStrings.howToGetAccessToken3),
          const Text(AppStrings.howToGetAccessToken4),
          const Text(AppStrings.howToGetAccessToken5),
          const SizedBox(height: 16),
          Text(
            AppStrings.accessTokenSecurityNotice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
