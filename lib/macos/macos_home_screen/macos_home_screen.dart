import 'package:anonaddy/features/account/presentation/account_tab.dart';
import 'package:anonaddy/macos/components/macos_sidebar_toggle.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosHomeScreen extends StatefulWidget {
  const MacosHomeScreen({Key? key}) : super(key: key);

  @override
  State<MacosHomeScreen> createState() => _MacosHomeScreenState();
}

class _MacosHomeScreenState extends State<MacosHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Home'),
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
            ContentArea(builder: (context, scrollController) {
              return const AccountTab();
            }),
          ],
        );
      },
    );
  }
}
