import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosSidebarToggle extends ToolBarIconButton {
  MacosSidebarToggle(
    BuildContext context, {
    String label = '',
    bool showLabel = false,
  }) : super(
          label: label,
          showLabel: showLabel,
          icon: const MacosIcon(CupertinoIcons.macwindow),
          onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
        );
}
