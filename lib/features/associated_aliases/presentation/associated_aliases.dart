import 'package:anonaddy/features/associated_aliases/presentation/controller/associated_aliases_notifier.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssociatedAliases extends ConsumerStatefulWidget {
  const AssociatedAliases({
    super.key,
    required this.aliasesCount,
    required this.params,
  });

  final int? aliasesCount;
  final Map<String, String> params;

  @override
  ConsumerState createState() => _AssociatedAliasesState();
}

class _AssociatedAliasesState extends ConsumerState<AssociatedAliases> {
  bool showAliases = false;

  void toggleLoadAliases() {
    setState(() {
      showAliases = !showAliases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aliases',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                onPressed: toggleLoadAliases,
                child: Text(showAliases ? 'Hide' : 'Show'),
              ),
            ],
          ),
        ),
        // if (widget.aliasesCount == null || widget.aliasesCount == 0)
        //   const Center(child: Text('No aliases found')),
        if (showAliases)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ref
                .watch(associatedAliasesNotifierProvider(widget.params))
                .when(
              data: (aliases) {
                if (aliases == null || aliases.isEmpty) {
                  return const Center(child: Text('No aliases found'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: aliases.length,
                  itemBuilder: (context, index) {
                    return AliasListTile(alias: aliases[index]);
                  },
                );
              },
              error: (error, _) {
                return ErrorMessageWidget(message: error.toString());
              },
              loading: () {
                return const Center(child: PlatformLoadingIndicator());
              },
            ),
          ),
      ],
    );
  }
}
