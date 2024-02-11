import 'package:anonaddy/features/search/presentation/controller/search_result/search_result_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTabHeader extends ConsumerWidget {
  SearchTabHeader({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchResultStateNotifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: searchState.searchController,
              validator: (input) => FormValidator.validateSearchField(input!),
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white),
              decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                hintText: AppStrings.searchFieldHint,
                hintStyle: const TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: closeIcon(context, ref, searchState.showCloseIcon!),
              ),
              onChanged: (input) {
                ref.read(searchResultStateNotifier.notifier).toggleCloseIcon();
                ref
                    .read(searchResultStateNotifier.notifier)
                    .searchAliasesLocally();
              },
              onFieldSubmitted: (keyword) {
                /// Validate input text characters are NOT less than 3 characters
                if (_formKey.currentState!.validate()) {
                  /// Triggers Full Search
                  ref.read(searchResultStateNotifier.notifier).searchAliases();
                }
              },
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Include deleted aliases',
                style: TextStyle(color: Colors.white),
              ),
              PlatformSwitch(
                value: searchState.includeDeleted!,
                onChanged: (toggle) {
                  ref
                      .read(searchResultStateNotifier.notifier)
                      .toggleIncludeDeleted(toggle);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? closeIcon(BuildContext context, WidgetRef ref, bool showCloseIcon) {
    if (showCloseIcon) {
      return IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          ref.read(searchResultStateNotifier.notifier).closeSearch();
        },
      );
    }
    return null;
  }
}
