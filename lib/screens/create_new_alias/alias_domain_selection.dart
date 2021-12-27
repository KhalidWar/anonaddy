import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDomainSelection extends StatelessWidget {
  const AliasDomainSelection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, controller) {
        return Consumer(
          builder: (context, watch, child) {
            final createAliasState = watch(createAliasStateNotifier);
            final domains = createAliasState.domains!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BottomSheetHeader(headerLabel: 'Select Alias Domain'),
                Expanded(
                  child: PlatformScrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      controller: controller,
                      physics: BouncingScrollPhysics(),
                      children: [
                        if (domains.isEmpty)
                          Center(
                            child: Text(
                              'No alias domain found',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: domains.length,
                            itemBuilder: (context, index) {
                              final domain = domains[index];
                              return ListTile(
                                dense: true,
                                selectedTileColor: kAccentColor,
                                horizontalTitleGap: 0,
                                title: Text(
                                  domain,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                onTap: () {
                                  context
                                      .read(createAliasStateNotifier.notifier)
                                      .setAliasDomain(domain);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
              ],
            );
          },
        );
      },
    );
  }
}
