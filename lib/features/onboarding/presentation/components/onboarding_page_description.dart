import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:flutter/material.dart';

class OnboardingPageDescription extends StatelessWidget {
  const OnboardingPageDescription({
    super.key,
    required this.title,
    required this.subtitle,
    required this.showAddyManagerLinks,
    required this.showDisclaimer,
  });

  final String title;
  final String subtitle;
  final bool showAddyManagerLinks;
  final bool showDisclaimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 360),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
          if (showAddyManagerLinks) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Privacy Policy'),
                  onPressed: () =>
                      Utilities.launchURL(kAddyManagerPrivacyPolicy),
                ),
                TextButton(
                  child: const Text('Terms & Conditions'),
                  onPressed: () =>
                      Utilities.launchURL(kAddyManagerTermsAndConditions),
                ),
              ],
            ),
            TextButton(
              child: const Text('Source Code'),
              onPressed: () => Utilities.launchURL(kAddyManagerRepoURL),
            ),
          ],
          if (showDisclaimer) ...[
            const SizedBox(height: 16),
            Text(
              'To sustain AddyManager\'s development, some power user features are now paid only, and your AddyManager subscription is separate from your Addy.io\'s account.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
