import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAliasSheet extends StatefulWidget {
  const CreateAliasSheet({
    Key key,
    this.apiDataManager,
  }) : super(key: key);

  final dynamic apiDataManager;

  @override
  _CreateAliasSheetState createState() => _CreateAliasSheetState();
}

class _CreateAliasSheetState extends State<CreateAliasSheet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController textFieldController = TextEditingController();
    String textFieldInput;

    return Container(
      height: size.height * 0.6,
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
                controller: textFieldController,
                // onChanged: (input) {
                //   textFieldInput = input;
                //   print(textFieldInput);
                // },
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
          // Spacer(),
          Container(
            width: double.infinity,
            child: RaisedButton(
              padding: EdgeInsets.all(15),
              child: Text(
                'Generate New Alias',
                style: Theme.of(context).textTheme.headline5,
              ),
              onPressed: () {
                print(textFieldInput);
                widget.apiDataManager.createNewAlias(
                    description: textFieldController.text.toString());
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

class DomainFormatWidget extends StatelessWidget {
  const DomainFormatWidget({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);
  final String label, value;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
