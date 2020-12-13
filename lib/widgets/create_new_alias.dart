import 'package:anonaddy/models/domain_options.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateNewAlias extends StatefulWidget {
  const CreateNewAlias({
    Key key,
  });

  @override
  _CreateNewAliasState createState() => _CreateNewAliasState();
}

class _CreateNewAliasState extends State<CreateNewAlias> {
  final _textFieldController = TextEditingController();
  bool isLoading = false;
  String defaultAliasDomain;
  String defaultAliasFormat;
  Future<DomainOptions> domainOptions;

  final aliasFormatList = <String>[
    'uuid',
    'random_words',
    // 'Custom',
  ];

  void createAlias(String defaultAliasDomain, String defaultAliasFormat) async {
    setState(() => isLoading = true);
    final response = await context.read(apiServiceProvider).createNewAlias(
        desc: _textFieldController.text.trim(),
        domain: defaultAliasDomain,
        format: defaultAliasFormat);

    if (response == '') {
      setState(() => isLoading = false);
      _textFieldController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    domainOptions = context.read(apiServiceProvider).getDomainOptions();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      width: size.width,
      child: FutureBuilder<DomainOptions>(
        future: domainOptions,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return null;
            case ConnectionState.waiting:
              return FetchingDataIndicator();
            default:
              final domain = snapshot.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _textFieldController,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Description (optional)',
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
                        value: defaultAliasDomain,
                        hint: Text('${domain.defaultAliasDomain}'),
                        items:
                            domain.data.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            defaultAliasDomain = value;
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
                        value: defaultAliasFormat,
                        hint: Text('${domain.defaultAliasFormat}'),
                        items: aliasFormatList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            defaultAliasFormat = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      child: isLoading
                          ? CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).appBarTheme.color)
                          : Text(
                              'Submit',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                      onPressed: () => createAlias(
                        defaultAliasDomain ?? domain.defaultAliasDomain,
                        defaultAliasFormat ?? domain.defaultAliasFormat,
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
