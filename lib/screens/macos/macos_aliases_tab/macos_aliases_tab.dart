import 'package:anonaddy/notifiers/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_state.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/screens/alias_tab/components/empty_list_alias_tab.dart';
import 'package:anonaddy/screens/macos/components/macos_sidebar_toggle.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosAliasesTab extends StatefulWidget {
  const MacosAliasesTab({Key? key}) : super(key: key);

  @override
  State<MacosAliasesTab> createState() => _MacosAliasesTabState();
}

class _MacosAliasesTabState extends State<MacosAliasesTab> {
  bool showAvailableAliases = true;

  void toggleAliases(bool showAvailable) {
    setState(() {
      showAvailableAliases = showAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Aliases Tab'),
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
                      title: const Text('Available Aliases'),
                      onTap: () => toggleAliases(true),
                    ),
                    ListTile(
                      title: const Text('Deleted Aliases'),
                      onTap: () => toggleAliases(false),
                    ),
                  ],
                );
              },
            ),
            ContentArea(
              builder: (context, scrollController) {
                return Consumer(
                  builder: (context, ref, child) {
                    final aliasTabState = ref.watch(aliasTabStateNotifier);

                    switch (aliasTabState.status) {
                      case AliasTabStatus.loading:
                        return const ProgressCircle();

                      case AliasTabStatus.loaded:
                        final availableAliasList =
                            aliasTabState.availableAliasList;
                        final deletedAliasList = aliasTabState.deletedAliasList;

                        if (showAvailableAliases) {
                          return availableAliasList.isEmpty
                              ? const EmptyListAliasTabWidget()
                              : ListView.builder(
                                  itemCount: availableAliasList.length,
                                  itemBuilder: (context, index) {
                                    return AliasListTile(
                                      key: AliasTabWidgetKeys
                                          .aliasTabAvailableAliasListTile,
                                      alias: availableAliasList[index],
                                    );
                                  },
                                );
                        }

                        return deletedAliasList.isEmpty
                            ? const EmptyListAliasTabWidget()
                            : ListView.builder(
                                itemCount: deletedAliasList.length,
                                itemBuilder: (context, index) {
                                  return AliasListTile(
                                    key: AliasTabWidgetKeys
                                        .aliasTabAvailableAliasListTile,
                                    alias: deletedAliasList[index],
                                  );
                                },
                              );

                      case AliasTabStatus.failed:
                        return ErrorMessageWidget(
                          message: aliasTabState.errorMessage,
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
