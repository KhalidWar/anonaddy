import 'package:anonaddy/features/domains/presentation/domains_tab.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_tab.dart';
import 'package:anonaddy/features/rules/presentation/rules_tab.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_tab.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/account_tab/components/account_tab_header.dart';
import 'package:anonaddy/screens/macos/components/macos_sidebar_toggle.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/paid_feature_blocker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

enum MacosAccountSubTabs { account, recipient, usernames, domains, rules }

class MacosAccountTab extends StatefulWidget {
  const MacosAccountTab({Key? key}) : super(key: key);

  @override
  State<MacosAccountTab> createState() => _MacosAccountTabState();
}

class _MacosAccountTabState extends State<MacosAccountTab> {
  MacosAccountSubTabs selectedTab = MacosAccountSubTabs.account;

  void updateSelectedTab(MacosAccountSubTabs newTab) {
    setState(() {
      selectedTab = newTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Account Tab'),
            actions: [
              ToolBarIconButton(
                label: 'Test',
                icon: const MacosIcon(CupertinoIcons.add),
                showLabel: false,
                onPressed: () {},
              ),
              MacosSidebarToggle(context),
            ],
          ),
          children: [
            ResizablePane(
              minSize: 150,
              startSize: 200,
              resizableSide: ResizableSide.right,
              builder: (context, controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Account'),
                      onTap: () =>
                          updateSelectedTab(MacosAccountSubTabs.account),
                    ),
                    ListTile(
                      title: const Text('Recipients'),
                      onTap: () =>
                          updateSelectedTab(MacosAccountSubTabs.recipient),
                    ),
                    ListTile(
                      trailing: IconButton(
                        icon: const MacosIcon(CupertinoIcons.add),
                        onPressed: () {},
                      ),
                      title: const Text('Usernames'),
                      onTap: () =>
                          updateSelectedTab(MacosAccountSubTabs.usernames),
                    ),
                    ListTile(
                      title: const Text('Domains'),
                      onTap: () =>
                          updateSelectedTab(MacosAccountSubTabs.domains),
                    ),
                    ListTile(
                      title: const Text('Rules'),
                      onTap: () => updateSelectedTab(MacosAccountSubTabs.rules),
                    ),
                  ],
                );
              },
            ),
            ContentArea(
              builder: (context, scrollController) {
                switch (selectedTab) {
                  case MacosAccountSubTabs.account:
                    return Container(
                      color: AppColors.primaryColor,
                      child: const AccountTabHeader(),
                    );

                  case MacosAccountSubTabs.recipient:
                    return const RecipientsTab();

                  case MacosAccountSubTabs.usernames:
                    return const PaidFeatureBlocker(
                      child: UsernamesTab(),
                    );

                  case MacosAccountSubTabs.domains:
                    return const PaidFeatureBlocker(
                      child: DomainsTab(),
                    );

                  case MacosAccountSubTabs.rules:
                    return const PaidFeatureBlocker(
                      child: RulesTab(),
                    );

                  default:
                    return const Center(child: Text('Wrong'));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
