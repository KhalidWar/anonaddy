import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';
import 'package:secure_application/secure_gate.dart';

class SecureGateScreen extends StatefulWidget {
  const SecureGateScreen({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _SecureGateScreenState createState() => _SecureGateScreenState();
}

class _SecureGateScreenState extends State<SecureGateScreen> {
  bool _didAuthenticate = false;

  Future<void> clearAppData(SecureApplicationController secureNotifier) async {
    await context
        .read(biometricAuthServiceProvider)
        .clearAppData(context)
        .whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TokenLoginScreen()),
      );
      secureNotifier.unlock();
    });
  }

  void authenticate() {
    final biometricAuth = context.read(biometricAuthServiceProvider);
    final isAppSecure = context.read(settingsStateManagerProvider).isAppSecured;
    if (isAppSecure == true) {
      biometricAuth
          .canCheckBiometrics()
          .then((value) => biometricAuth.authenticate(value))
          .then((value) {
        setState(() {
          _didAuthenticate = value;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      blurr: 20,
      opacity: 0.6,
      child: widget.child,
      lockedBuilder: (context, secureNotifier) {
        if (_didAuthenticate == true) {
          secureNotifier.unlock();
        } else {
          secureNotifier.lock();
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: kBlueNavyColor,
            systemNavigationBarColor: kBlueNavyColor,
          ),
          child: Container(
            width: double.infinity,
            color: kBlueNavyColor,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: LottieWidget(
                    lottie: 'assets/lottie/biometric.json',
                    repeat: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Unlock now!',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      onPressed: () => authenticate(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Reset App',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      // onPressed: () {},
                      onPressed: () => clearAppData(secureNotifier),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
