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

  final aliasFormatList = <String>[
    'uuid',
    'random_words',
    // 'Custom',
  ];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptions = watch(domainOptionsProvider);
    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isLoading;
    final createNewAlias = aliasStateProvider.createNewAlias;

    return domainOptions.when(
      loading: () => FetchingDataIndicator(),
      data: (data) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: _textFieldController,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                decoration: kTextFormFieldDecoration.copyWith(
                  hintText: kDescriptionInputText,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Domain',
                  style: Theme.of(context).textTheme.headline6,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: aliasStateProvider.aliasDomain,
                  hint: Text('${data.defaultAliasDomain}'),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alias',
                  style: Theme.of(context).textTheme.headline6,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: aliasStateProvider.aliasFormat,
                  hint: Text('${data.defaultAliasFormat}'),
                  items: aliasFormatList.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    aliasStateProvider.setAliasFormat = value;
                  },
                ),
              ],
            ),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                child: isLoading
                    ? CircularProgressIndicator(backgroundColor: kBlueNavyColor)
                    : Text(
                        'Submit',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                onPressed: isLoading
                    ? () {}
                    : () => createNewAlias(
                          context,
                          _textFieldController.text.trim(),
                          aliasStateProvider.aliasDomain ??
                              data.defaultAliasDomain,
                          aliasStateProvider.aliasFormat ??
                              data.defaultAliasFormat,
                        ),
                // onPressed: () => createAlias(context, data),
              ),
            ),
          ],
        );
      },
      error: (error, stackTrade) => LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        label: error,
        lottieHeight: MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }
}
