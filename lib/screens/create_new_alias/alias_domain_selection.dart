import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';

class AliasDomainSelection extends StatelessWidget {
  const AliasDomainSelection({
    required this.domainOptions,
    required this.setAliasDomain,
  });
  final DomainOptions domainOptions;
  final Function(String) setAliasDomain;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, controller) {
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
                    if (domainOptions.domains.isEmpty)
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
                        itemCount: domainOptions.domains.length,
                        itemBuilder: (context, index) {
                          final domain = domainOptions.domains[index];
                          return ListTile(
                            dense: true,
                            selectedTileColor: kAccentColor,
                            horizontalTitleGap: 0,
                            title: Text(
                              domain,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            onTap: () => setAliasDomain(domain),
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
  }
}
