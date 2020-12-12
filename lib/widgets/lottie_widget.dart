import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  const LottieWidget({
    Key key,
    this.label,
    this.iconData,
    this.buttonLabel,
    this.buttonOnPress,
    this.iconColor,
    this.scaffoldColor,
    this.lottie,
    this.lottieHeight,
  }) : super(key: key);

  final String label, buttonLabel, lottie;
  final IconData iconData;
  final Function buttonOnPress;
  final Color iconColor, scaffoldColor;
  final double lottieHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            lottie == null
                ? Container()
                : Lottie.asset(
                    lottie,
                    height: lottieHeight,
                    fit: BoxFit.fitHeight,
                    repeat: false,
                  ),
            label == null
                ? Container()
                : Text(
                    '$label',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
          ],
        ),
      ),
    );
  }
}
