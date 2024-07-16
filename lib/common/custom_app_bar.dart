import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(
    this.context, {
    super.key,
    required this.label,
    this.dropdownOptions = const [],
  });

  final BuildContext context;
  final String label;
  final List<AppBarDropdownOption> dropdownOptions;

  @override
  Widget? get leading {
    return IconButton(
      icon: Icon(
        PlatformAware.isIOS() ? CupertinoIcons.back : Icons.arrow_back,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget? get title => Text(label);

  @override
  List<Widget>? get actions {
    if (dropdownOptions.isNotEmpty) {
      return PlatformAware.isIOS()
          ? [buildIosDropdown()]
          : [buildAndroidDropdown()];
    }

    return null;
  }

  Widget buildIosDropdown() {
    return PullDownButton(
      itemBuilder: (context) {
        return dropdownOptions.map((choice) {
          return PullDownMenuItem(
            title: choice.label,
            onTap: () async {
              await PlatformAware.platformDialog(
                context: context,
                child: PlatformAlertDialog(
                  title: choice.label,
                  content: choice.content,
                  method: choice.onTap,
                ),
              );
            },
          );
        }).toList();
      },
      buttonBuilder: (context, showMenu) {
        return CupertinoButton(
          onPressed: showMenu,
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis),
        );
      },
    );
  }

  Widget buildAndroidDropdown() {
    return PopupMenuButton(
      icon: Icon(Icons.adaptive.more),
      itemBuilder: (BuildContext context) {
        return dropdownOptions.map((choice) {
          return PopupMenuItem<String>(
            value: choice.label,
            child: Text(choice.label),
            onTap: () async {
              await PlatformAware.platformDialog(
                context: context,
                child: PlatformAlertDialog(
                  title: choice.label,
                  content: choice.content,
                  method: choice.onTap,
                ),
              );
            },
          );
        }).toList();
      },
      // onSelected: dropdownOnSelected,
    );
  }
}

class AppBarDropdownOption {
  const AppBarDropdownOption({
    required this.label,
    required this.content,
    required this.onTap,
  });

  final String label;
  final String content;
  final Function() onTap;
}
