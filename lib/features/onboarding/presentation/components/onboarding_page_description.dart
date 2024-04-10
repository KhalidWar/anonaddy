import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';

class OnboardingPageDescription extends StatelessWidget {
  const OnboardingPageDescription({
    super.key,
    required this.title,
    required this.subtitle,
    required this.showButton,
  });

  final String title;
  final String subtitle;
  final bool showButton;

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
          if (showButton) ...[
            const SizedBox(height: 16),
            TextButton(
              child: const Text('Source Code'),
              onPressed: () => Utilities.launchURL(kAddyManagerRepoURL),
            ),
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
          ],
        ],
      ),
    );
  }
}
