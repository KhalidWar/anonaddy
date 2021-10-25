import 'package:anonaddy/screens/alias_tab/components/cupertino_alias_tab.dart';
import 'package:anonaddy/screens/alias_tab/components/material_alias_tab.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAliasTab extends PlatformAware {
  const PlatformAliasTab();

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return const CupertinoAliasTab();
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return const MaterialAliasTab();
  }
}
