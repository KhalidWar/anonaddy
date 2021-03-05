import 'package:anonaddy/screens/login_screen/initial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_application/secure_gate.dart';

import '../../constants.dart';

class SecureGateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecureGate(
      blurr: 20,
      opacity: 0.6,
      child: InitialScreen(),
      lockedBuilder: (context, secureNotifier) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: kBlueNavyColor,
            systemNavigationBarColor: kBlueNavyColor,
          ),
          child: Container(
            width: double.infinity,
            color: kBlueNavyColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('UNLOCK'),
                  onPressed: () => secureNotifier.authSuccess(unlock: true),
                ),
                RaisedButton(
                  child: Text('FAIL AUTHENTICATION'),
                  onPressed: () => secureNotifier.authFailed(unlock: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
