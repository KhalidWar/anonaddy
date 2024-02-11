import 'package:anonaddy/features/search/presentation/components/search_history.dart';
import 'package:anonaddy/macos/components/macos_sidebar_toggle.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:flutter/cupertino.dart';
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
                return const SearchHistory();
              },
            ),
          ],
        );
      },
    );
  }
}
