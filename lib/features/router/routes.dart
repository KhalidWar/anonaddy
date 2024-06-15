import 'package:anonaddy/features/router/app_router.dart';
import 'package:auto_route/auto_route.dart';

enum AppRoutes {
  /// Onboarding screen handles the onboarding process for new users,
  /// and contains addy.io login and self-hosted login.
  onboarding('/onboarding', OnboardingScreenRoute.page),
  lockScreen('/lock-screen', LockScreenRoute.page),
  appStartup('/app-startup', AppStartupScreenRoute.page),

  /// Home
  home('/home', HomeScreenRoute.page),
  notifications('/notifications', NotificationsScreenRoute.page),
  failedDeliveries('/failed-deliveries', UsernamesTabRoute.page),
  // failedDelivery(':id', FailedDeliveryScreenRoute.page),
  searchTab('search-tab', SearchTabRoute.page),
  quickSearch('/quick-search', QuickSearchScreenRoute.page),
  createAlias('create-alias', CreateAliasRoute.page),

  /// Aliases
  aliases('aliases', AliasesTabRoute.page),
  alias('/:id', AliasScreenRoute.page),

  /// Account Tab
  account('account', AccountTabRoute.page),
  recipients('recipients', RecipientsTabRoute.page),
  recipient('/:id', RecipientsScreenRoute.page),
  usernames('usernames', UsernamesTabRoute.page),
  username('/:id', UsernamesScreenRoute.page),
  domains('domains', DomainsTabRoute.page),
  domain('/:id', DomainScreenRoute.page),
  rules('rules', RulesTabRoute.page),
  // rule('/:id', RuleScreenRoute.page),

  /// Settings
  settings('/settings', SettingsScreenRoute.page),
  aboutApp('/about-app', AboutAppScreenRoute.page),
  credits('/credits', CreditsScreenRoute.page);

  final String path;
  final PageInfo page;

  const AppRoutes(this.path, this.page);
}
