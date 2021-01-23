import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import 'alias_tab.dart';

class CreateNewAlias extends ConsumerWidget {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptions = watch(domainOptionsProvider);

    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isLoading;
    final createNewAlias = aliasStateProvider.createNewAlias;
    final aliasFormatList = aliasStateProvider.aliasFormatList;

    String correctAliasString(String input) {
      switch (input) {
        case 'random_words':
          return 'Random Words';
        case 'uuid':
          return 'UUID';
        case 'random_characters':
          return 'Random Characters';
      }
    }

    return domainOptions.when(
      loading: () => FetchingDataIndicator(),
      data: (data) {
        return Column(
          children: [
            TextFormField(
              controller: _textFieldController,
              textInputAction: TextInputAction.next,
              decoration: kTextFormFieldDecoration.copyWith(
                hintText: kDescriptionInputText,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alias domain',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: aliasStateProvider.aliasDomain,
                  hint: Text(
                    '${data.defaultAliasDomain ?? 'Choose Alias Domain'}',
                  ),
                  items: data.data.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    aliasStateProvider.setAliasDomain = value;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alias format',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: aliasStateProvider.aliasFormat,
                  hint: Text(
                    '${data.defaultAliasFormat ?? 'Choose Alias Format'}',
                  ),
                  items: aliasFormatList.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(correctAliasString(value)),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    aliasStateProvider.setAliasFormat = value;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: isLoading
                  ? CircularProgressIndicator(backgroundColor: kBlueNavyColor)
                  : Text(
                      'Submit',
                      style: Theme.of(context).textTheme.headline5,
                    ),
              onPressed: isLoading
                  ? () {}
                  : () {
                      if (aliasStateProvider.aliasDomain == null &&
                              data.defaultAliasDomain == null ||
                          aliasStateProvider.aliasFormat == null &&
                              data.defaultAliasFormat == null) {
                      } else {
                        createNewAlias(
                          context,
                          _textFieldController.text.trim(),
                          aliasStateProvider.aliasDomain ??
                              data.defaultAliasDomain,
                          aliasStateProvider.aliasFormat ??
                              data.defaultAliasFormat,
                        );
                      }
                    },
            ),
          ],
        );
      },
      error: (error, stackTrade) {
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: error,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
        );
      },
    );
  }
}
