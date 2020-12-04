import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key key,
    this.label,
    this.buttonLabel,
    this.buttonOnPress,
  }) : super(key: key);

  final String label, buttonLabel;
  final Function buttonOnPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: size.height * 0.1,
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          buttonLabel == null
              ? Container()
              : RaisedButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.2,
                    vertical: 20,
                  ),
                  child: Text(
                    buttonLabel,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onPressed: buttonOnPress,
                ),
        ],
      ),
    );
  }
}
