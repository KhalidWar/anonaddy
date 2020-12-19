import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';

final _textFieldController = StateProvider((ref) => TextEditingController());
final _isLoading = StateProvider<bool>((ref) => false);

final _defaultAliasDomain = StateProvider<String>((ref) => null);
final _defaultAliasFormat = StateProvider<String>((ref) => null);

class CreateNewAlias extends StatefulWidget {
  CreateNewAlias({Key key, this.domainOptions});

  final AsyncValue<DomainOptions> domainOptions;

  @override
  _CreateNewAliasState createState() => _CreateNewAliasState();
}

class _CreateNewAliasState extends State<CreateNewAlias> {
  final aliasFormatList = <String>[
    'uuid',
    'random_words',
    // 'Custom',
  ];

  void createAlias(BuildContext context, DomainOptions data) async {
    setState(() {
      context.read(_isLoading).state = true;
    });
    final response = await context.read(aliasServiceProvider).createNewAlias(
          desc: context.read(_textFieldController).state.text.trim(),
          domain: context.read(_defaultAliasDomain).state ??
              data.defaultAliasDomain,
          format: context.read(_defaultAliasFormat).state ??
              data.defaultAliasFormat,
        );

    if (response == 201) {
      setState(() {
        context.read(_isLoading).state = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Alias created successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
      );
    } else {
      setState(() {
        context.read(_isLoading).state = false;
      });
      Fluttertoast.showToast(
        msg: 'Failed to create alias',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.domainOptions.when(
      loading: () => FetchingDataIndicator(),
      data: (data) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text('Create New Alias'),
          children: [
            Container(
              height: size.height * 0.4,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: context.read(_textFieldController).state,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: kDescriptionInputText,
                    ),
                  ),
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
                        value: context.read(_defaultAliasDomain).state,
                        hint: Text('${data.defaultAliasDomain}'),
                        items: data.data.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            context.read(_defaultAliasDomain).state = value;
                          });
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
                        value: context.read(_defaultAliasFormat).state,
                        hint: Text('${data.defaultAliasFormat}'),
                        items: aliasFormatList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            context.read(_defaultAliasFormat).state = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      child: context.read(_isLoading).state
                          ? CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).appBarTheme.color,
                            )
                          : Text(
                              'Submit',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                      // onPressed: () {},
                      onPressed: () => createAlias(context, data),
                    ),
                  ),
                ],
              ),
            ),
            // CreateNewAlias(domainOptions: domainOptions),
          ],
        );
      },
      error: (error, stackTrade) => LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        label: error,
      ),
    );
  }
}
