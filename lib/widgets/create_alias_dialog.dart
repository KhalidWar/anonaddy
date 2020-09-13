import 'package:flutter/material.dart';

class CreateAliasDialog extends StatelessWidget {
  const CreateAliasDialog({
    Key key,
    this.textFieldOnChanged,
    this.domain,
    this.format,
    this.buttonOnPress,
  }) : super(key: key);

  final Function textFieldOnChanged, buttonOnPress;
  final String domain, format;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SimpleDialog(
      title: Text('Generate Alias'),
      contentPadding: EdgeInsets.all(15),
      titleTextStyle: Theme.of(context).textTheme.headline5,
      children: [
        Container(
          height: size.height * 0.3,
          width: size.width * 0.8,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Description (optional)',
                  ),
                  onChanged: textFieldOnChanged,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Domain:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      domain,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Format:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      format,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Generate New Alias',
                  style: Theme.of(context).textTheme.headline5,
                ),
                onPressed: buttonOnPress,
              )
            ],
          ),
        ),
      ],
    );
  }
}
