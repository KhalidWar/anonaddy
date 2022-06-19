import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    required String title,
    required Function() leadingOnPress,
    required bool showTrailing,
    String? trailingLabel,
    Function(String)? trailingOnPress,
  }) : super(
          key: key,
          leading: IconButton(
            icon: Icon(
              PlatformAware.isIOS() ? CupertinoIcons.back : Icons.arrow_back,
            ),
            color: Colors.white,
            onPressed: leadingOnPress,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          actions: showTrailing
              ? [
                  PopupMenuButton(
                    icon: Icon(
                      Icons.adaptive.more,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) {
                      return [trailingLabel ?? ''].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    onSelected: trailingOnPress,
                  ),
                ]
              : null,
        );
}
