import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/material.dart';

import 'domain_format_widget.dart';

class CreateNewAlias extends StatefulWidget {
  const CreateNewAlias({Key key}) : super(key: key);

  @override
  _CreateNewAliasState createState() => _CreateNewAliasState();
}

class _CreateNewAliasState extends State<CreateNewAlias> {
  TextEditingController _textFieldController = TextEditingController();

  bool _isLoading = false;
  String _error = '';

  _createNewAlias() async {
    setState(() => _isLoading = true);
    dynamic response = await serviceLocator<APIService>().createNewAlias(
        description: _textFieldController.text.trim() ?? 'No Description');

    // print(response); //todo add response data (if not null) to stream?
    if (response == null) {
      setState(() {
        _isLoading = false;
        _error = 'Could not create alias.\nSomething went wrong';
      });
    } else {
      setState(() => _isLoading = false);
      Navigator.pop(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        height: size.height * 0.6,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Divider(
                  thickness: 3,
                  color: Colors.grey,
                  indent: size.width * 0.35,
                  endIndent: size.width * 0.35,
                ),
                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _textFieldController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Description (optional)',
                  ),
                ),
              ],
            ),
            Column(
              children: [
                DomainFormatWidget(label: 'Domain:', value: '@anonaddy.me'),
                SizedBox(height: size.height * 0.03),
                DomainFormatWidget(label: 'Format:', value: 'UUID'),
              ],
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _error,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.red, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  width: size.width * 0.6,
                  child: RaisedButton(
                    padding: EdgeInsets.all(15),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            backgroundColor:
                                Theme.of(context).appBarTheme.color,
                          )
                        : Text(
                            'Create New Alias',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                    onPressed: _isLoading
                        ? () {}
                        : () {
                            _createNewAlias();
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
