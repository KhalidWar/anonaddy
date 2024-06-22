// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AboutAppScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutAppScreen(),
      );
    },
    AccountInfoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountInfo(),
      );
    },
    AccountTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountTab(),
      );
    },
    AliasScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AliasScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AliasScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    AliasesTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AliasesTab(),
      );
    },
    AppStartupScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppStartupScreen(),
      );
    },
    CreateAliasRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateAlias(),
      );
    },
    CreditsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreditsScreen(),
      );
    },
    DomainScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DomainScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DomainScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    DomainsTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DomainsTab(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LockScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LockScreen(),
      );
    },
    NotificationsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsScreen(),
      );
    },
    OnboardingScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    QuickSearchScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const QuickSearchScreen(),
      );
    },
    RecipientsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<RecipientsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecipientsScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    RecipientsTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RecipientsTab(),
      );
    },
    RulesTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RulesTab(),
      );
    },
    SearchTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchTab(),
      );
    },
    SettingsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    UsernamesScreenRoute.name: (routeData) {
      final args = routeData.argsAs<UsernamesScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UsernameScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    UsernamesTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UsernamesTab(),
      );
    },
  };
}

/// generated route for
/// [AboutAppScreen]
class AboutAppScreenRoute extends PageRouteInfo<void> {
  const AboutAppScreenRoute({List<PageRouteInfo>? children})
      : super(
          AboutAppScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutAppScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountInfo]
class AccountInfoRoute extends PageRouteInfo<void> {
  const AccountInfoRoute({List<PageRouteInfo>? children})
      : super(
          AccountInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountInfoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountTab]
class AccountTabRoute extends PageRouteInfo<void> {
  const AccountTabRoute({List<PageRouteInfo>? children})
      : super(
          AccountTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AliasScreen]
class AliasScreenRoute extends PageRouteInfo<AliasScreenRouteArgs> {
  AliasScreenRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          AliasScreenRoute.name,
          args: AliasScreenRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'AliasScreenRoute';

  static const PageInfo<AliasScreenRouteArgs> page =
      PageInfo<AliasScreenRouteArgs>(name);
}

class AliasScreenRouteArgs {
  const AliasScreenRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'AliasScreenRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [AliasesTab]
class AliasesTabRoute extends PageRouteInfo<void> {
  const AliasesTabRoute({List<PageRouteInfo>? children})
      : super(
          AliasesTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'AliasesTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppStartupScreen]
class AppStartupScreenRoute extends PageRouteInfo<void> {
  const AppStartupScreenRoute({List<PageRouteInfo>? children})
      : super(
          AppStartupScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppStartupScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreateAlias]
class CreateAliasRoute extends PageRouteInfo<void> {
  const CreateAliasRoute({List<PageRouteInfo>? children})
      : super(
          CreateAliasRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAliasRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreditsScreen]
class CreditsScreenRoute extends PageRouteInfo<void> {
  const CreditsScreenRoute({List<PageRouteInfo>? children})
      : super(
          CreditsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreditsScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DomainScreen]
class DomainScreenRoute extends PageRouteInfo<DomainScreenRouteArgs> {
  DomainScreenRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          DomainScreenRoute.name,
          args: DomainScreenRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'DomainScreenRoute';

  static const PageInfo<DomainScreenRouteArgs> page =
      PageInfo<DomainScreenRouteArgs>(name);
}

class DomainScreenRouteArgs {
  const DomainScreenRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'DomainScreenRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [DomainsTab]
class DomainsTabRoute extends PageRouteInfo<void> {
  const DomainsTabRoute({List<PageRouteInfo>? children})
      : super(
          DomainsTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'DomainsTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<void> {
  const HomeScreenRoute({List<PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LockScreen]
class LockScreenRoute extends PageRouteInfo<void> {
  const LockScreenRoute({List<PageRouteInfo>? children})
      : super(
          LockScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LockScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationsScreen]
class NotificationsScreenRoute extends PageRouteInfo<void> {
  const NotificationsScreenRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen]
class OnboardingScreenRoute extends PageRouteInfo<void> {
  const OnboardingScreenRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [QuickSearchScreen]
class QuickSearchScreenRoute extends PageRouteInfo<void> {
  const QuickSearchScreenRoute({List<PageRouteInfo>? children})
      : super(
          QuickSearchScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuickSearchScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RecipientsScreen]
class RecipientsScreenRoute extends PageRouteInfo<RecipientsScreenRouteArgs> {
  RecipientsScreenRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          RecipientsScreenRoute.name,
          args: RecipientsScreenRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipientsScreenRoute';

  static const PageInfo<RecipientsScreenRouteArgs> page =
      PageInfo<RecipientsScreenRouteArgs>(name);
}

class RecipientsScreenRouteArgs {
  const RecipientsScreenRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'RecipientsScreenRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [RecipientsTab]
class RecipientsTabRoute extends PageRouteInfo<void> {
  const RecipientsTabRoute({List<PageRouteInfo>? children})
      : super(
          RecipientsTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecipientsTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RulesTab]
class RulesTabRoute extends PageRouteInfo<void> {
  const RulesTabRoute({List<PageRouteInfo>? children})
      : super(
          RulesTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'RulesTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchTab]
class SearchTabRoute extends PageRouteInfo<void> {
  const SearchTabRoute({List<PageRouteInfo>? children})
      : super(
          SearchTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen]
class SettingsScreenRoute extends PageRouteInfo<void> {
  const SettingsScreenRoute({List<PageRouteInfo>? children})
      : super(
          SettingsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UsernameScreen]
class UsernamesScreenRoute extends PageRouteInfo<UsernamesScreenRouteArgs> {
  UsernamesScreenRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          UsernamesScreenRoute.name,
          args: UsernamesScreenRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'UsernamesScreenRoute';

  static const PageInfo<UsernamesScreenRouteArgs> page =
      PageInfo<UsernamesScreenRouteArgs>(name);
}

class UsernamesScreenRouteArgs {
  const UsernamesScreenRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'UsernamesScreenRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [UsernamesTab]
class UsernamesTabRoute extends PageRouteInfo<void> {
  const UsernamesTabRoute({List<PageRouteInfo>? children})
      : super(
          UsernamesTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'UsernamesTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
