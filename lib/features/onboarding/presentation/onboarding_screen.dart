import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/monetization/presentation/controller/monetization_notifier.dart';
import 'package:anonaddy/features/monetization/presentation/monetization_paywall.dart';
import 'package:anonaddy/features/onboarding/presentation/components/addy_login.dart';
import 'package:anonaddy/features/onboarding/presentation/components/onboarding_page_description.dart';
import 'package:anonaddy/features/onboarding/presentation/components/onboarding_page_image.dart';
import 'package:anonaddy/features/onboarding/presentation/components/self_host_login.dart';
import 'package:anonaddy/features/onboarding/presentation/onboarding_pages.dart';
import 'package:anonaddy/theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'OnboardingScreenRoute')
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

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
          controllerColor: Theme.of(context).primaryColor,
          finishButtonText: 'Login',
          finishButtonStyle: FinishButtonStyle(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onFinish: () async {
            ref.read(monetizationNotifierProvider.notifier).showPaywall();

            await WoltModalSheet.show(
              context: context,
              pageListBuilder: (context) {
                return [
                  Utilities.buildWoltModalSheetSubPage(
                    context,
                    topBarTitle: 'Addy.io Login',
                    pageTitle: AppStrings.accessTokenRequired,
                    child: const AddyLogin(),
                  ),
                ];
              },
            );
          },
          skipTextButton: const Text('Skip'),
          trailing: const Text('Self Hosting?'),
          trailingFunction: () async {
            await WoltModalSheet.show(
              context: context,
              pageListBuilder: (context) {
                return [
                  Utilities.buildWoltModalSheetSubPage(
                    context,
                    topBarTitle: 'Self Hosted Instance Login',
                    pageTitle:
                        'AddyManager fully supports self-hosted instances',
                    child: const MonetizationPaywall(
                      showListTimeShimmer: false,
                      child: SelfHostLogin(),
                    ),
                  ),
                ];
              },
            );
          },
          background: OnboardingPages.values.map((page) {
            return OnboardingPageImage(svgPath: page.path);
          }).toList(),
          totalPage: OnboardingPages.values.length,
          pageBodies: OnboardingPages.values.map((page) {
            return OnboardingPageDescription(
              title: page.title,
              subtitle: page.subtitle,
              showAddyManagerLinks: page.showAddyManagerLinks,
              showDisclaimer: page.showDisclaimer,
            );
          }).toList(),
        ),
      ),
    );
  }
}
