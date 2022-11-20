import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_state.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/macos/components/macos_sidebar_toggle.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosSearchTab extends StatefulWidget {
  const MacosSearchTab({Key? key}) : super(key: key);

  @override
  State<MacosSearchTab> createState() => _MacosSearchTabState();
}

class _MacosSearchTabState extends State<MacosSearchTab> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Search History'),
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
            ContentArea(
              builder: (context, scrollController) {
                return Consumer(
                  builder: (context, ref, child) {
                    final searchState = ref.watch(searchHistoryStateNotifier);

                    switch (searchState.status) {
                      case SearchHistoryStatus.loading:
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );

                      case SearchHistoryStatus.loaded:
                        final aliases = searchState.aliases;

                        if (aliases.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                                children: const [Text('Nothing to see here.')]),
                          );
                        } else {
                          return Expanded(
                            child: PlatformScrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: aliases.length,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AliasListTile(alias: aliases[index]);
                                },
                              ),
                            ),
                          );
                        }

                      case SearchHistoryStatus.failed:
                        final error = searchState.errorMessage;
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Text(error ??
                                  'Something went wrong: ${error.toString()}'),
                            ],
                          ),
                        );
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
