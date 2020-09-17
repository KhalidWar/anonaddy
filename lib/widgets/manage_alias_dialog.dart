import 'package:flutter/material.dart';

class ManageAliasDialog extends StatelessWidget {
  const ManageAliasDialog({
    Key key,
    this.title,
    this.emailDescription,
    this.deleteOnPress,
  }) : super(key: key);

  final String title, emailDescription;
  final Function deleteOnPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String textFieldInput = emailDescription;

    return SimpleDialog(
      contentPadding: EdgeInsets.all(15),
      title: Text('Manage Alias'),
      children: [
        Text('$title', style: Theme.of(context).textTheme.bodyText1),
        SizedBox(height: size.height * 0.03),
        Text(
          'Edit Description:',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        TextField(
          onChanged: (input) {
            //todo implement edit description
            input = textFieldInput;
          },
          decoration: InputDecoration(
            hintText: '$emailDescription',
            hintStyle: Theme.of(context).textTheme.headline6,
            suffixIcon: Icon(Icons.edit),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delete Alias',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: deleteOnPress,
            ),
          ],
        ),
        RaisedButton(
          child: Text('Submit'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
