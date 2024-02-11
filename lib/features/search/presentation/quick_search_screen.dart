import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/search/presentation/controller/quick_search/quick_search_notifier.dart';
import 'package:anonaddy/features/search/presentation/controller/search_history/search_history_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickSearchScreen extends ConsumerStatefulWidget {
  const QuickSearchScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = 'quickSearchScreen';

  @override
  ConsumerState createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends ConsumerState<QuickSearchScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SearchAppBar(
        leadingOnPress: () => Navigator.pop(context),
        inputField: TextFormField(
          controller: controller,
          autofocus: true,
          autocorrect: false,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppStrings.searchFieldHint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            focusedBorder: InputBorder.none,
          ),
          onChanged: (input) {
            ref.read(quickSearchNotifierProvider.notifier).search(input);
            setState(() {});
          },
        ),
        trailing: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    controller.clear();
                    ref
                        .read(quickSearchNotifierProvider.notifier)
                        .resetSearch();
                  });
                },
              )
            : const SizedBox(),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final searchState = ref.watch(quickSearchNotifierProvider);

          return searchState.when(
            data: (aliases) {
              if (aliases == null) {
                return Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Start searching'),
                );
              }

              if (aliases.isEmpty) {
                return Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(20),
                  child: const Text('No aliases found'),
                );
              }

              return PlatformScrollbar(
                child: ListView.builder(
                  itemCount: aliases.length,
                  itemBuilder: (context, index) {
                    final alias = aliases[index];
                    return InkWell(
                      child: IgnorePointer(
                        child: AliasListTile(alias: alias),
                      ),
                      onTap: () {
                        /// Dismisses keyboard
                        FocusScope.of(context).requestFocus(FocusNode());

                        /// Add selected Alias to Search History
                        ref
                            .read(searchHistoryStateNotifier.notifier)
                            .addAliasToSearchHistory(alias);

                        /// Navigate to Alias Screen
                        Navigator.pushNamed(
                          context,
                          AliasScreen.routeName,
                          arguments: alias.id,
                        );
                      },
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20),
                child: Text(error.toString()),
              );
            },
            loading: () {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20),
                child: const PlatformLoadingIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}

class _SearchAppBar extends AppBar {
  _SearchAppBar({
    Key? key,
    required this.inputField,
    required Function() leadingOnPress,
    required Widget trailing,
  }) : super(
          key: key,
          title: inputField,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              PlatformAware.isIOS() ? CupertinoIcons.back : Icons.arrow_back,
            ),
            color: Colors.white,
            onPressed: leadingOnPress,
          ),
          actions: [trailing],
        );

  final Widget inputField;
}
