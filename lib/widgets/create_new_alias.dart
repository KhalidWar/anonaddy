import 'package:anonaddy/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain_format_widget.dart';

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

  void createAlias() async {
    setState(() => isLoading = true);
    final response = await context
        .read(apiServiceProvider)
        .createNewAlias(_textFieldController.text);

    if (response == '') {
      setState(() => isLoading = false);
      _textFieldController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            children: [
              DomainFormatWidget(label: 'Domain:', value: '@anonaddy.me'),
              SizedBox(height: size.height * 0.03),
              DomainFormatWidget(label: 'Format:', value: 'UUID'),
            ],
          ),
          Container(
            width: size.width * 0.6,
            child: RaisedButton(
              padding: EdgeInsets.all(15),
              child: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                    )
                  : Text(
                      'Submit',
                      style: Theme.of(context).textTheme.headline5,
                    ),
              onPressed: () => createAlias(),
            ),
          ),
        ],
      ),
    );
  }
}
