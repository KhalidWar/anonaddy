import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_notifier.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTabHeader extends StatelessWidget {
  SearchTabHeader({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          kSearchAliasByEmailOrDesc,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: size.height * 0.01),
        Consumer(
          builder: (context, watch, _) {
            final searchState = watch(searchResultStateNotifier);

            return Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: searchState.searchController,
                    validator: (input) =>
                        FormValidator.validateSearchField(input!),
                    textInputAction: TextInputAction.search,
                    style: TextStyle(color: Colors.white),
                    decoration: kTextFormFieldDecoration.copyWith(
                      hintText: kSearchFieldHint,
                      suffixIcon:
                          closeIcon(context, searchState.showCloseIcon!),
                    ),
                    onChanged: (input) {
                      context
                          .read(searchResultStateNotifier.notifier)
                          .toggleCloseIcon();
                      context
                          .read(searchResultStateNotifier.notifier)
                          .searchAliasesLocally();
                    },
                    onFieldSubmitted: (keyword) {
                      /// Validate input text characters are NOT less than 3 characters
                      if (_formKey.currentState!.validate()) {
                        /// Triggers Full Search
                        context
                            .read(searchResultStateNotifier.notifier)
                            .searchAliases();
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Include deleted aliases',
                      style: TextStyle(color: Colors.white),
                    ),
                    PlatformSwitch(
                      value: searchState.includeDeleted!,
                      onChanged: (toggle) {
                        context
                            .read(searchResultStateNotifier.notifier)
                            .toggleIncludeDeleted(toggle);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget? closeIcon(BuildContext context, bool showCloseIcon) {
    if (showCloseIcon) {
      return IconButton(
        icon: Icon(Icons.close, color: Colors.white),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          context.read(searchResultStateNotifier.notifier).closeSearch();
        },
      );
    }
  }
}
