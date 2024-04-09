import 'package:anonaddy/features/onboarding/presentation/components/onboarding_page_description.dart';
import 'package:anonaddy/features/onboarding/presentation/components/onboarding_page_image.dart';
import 'package:anonaddy/features/onboarding/presentation/onboarding_pages.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'onboardingScreen';

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Scaffold(
        body: OnBoardingSlider(
          speed: 1.8,
          centerBackground: true,
          headerBackgroundColor: Colors.white,
          // leading: const Text('Leading'),
          controllerColor: Theme.of(context).primaryColor,
          finishButtonText: 'Login with API Token',
          onFinish: () {
            // Navigator.of(context).pushNamed(LoginScreen.routeName);
          },
          skipTextButton: const Text('Skip'),
          trailing: const Text('Self Hosting?'),
          trailingFunction: () {
            // Navigator.of(context).pushNamed(LoginScreen.routeName);
          },
          background: OnboardingPages.values.map((page) {
            return OnboardingPageImage(svgPath: page.path);
          }).toList(),
          totalPage: OnboardingPages.values.length,
          pageBodies: OnboardingPages.values.map((page) {
            return OnboardingPageDescription(
              title: page.title,
              subtitle: page.subtitle,
              showButton: page.showAddyManagerLinks,
            );
          }).toList(),
        ),
      ),
    );
  }
}
