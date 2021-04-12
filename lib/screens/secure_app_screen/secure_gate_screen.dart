import 'package:animations/animations.dart';
import 'package:anonaddy/screens/login_screen/logout_screen.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/material.dart';
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

  Future<void> authenticate() async {
    final showToast = context.read(aliasStateManagerProvider).showToast;
    final biometricAuth = context.read(biometricAuthServiceProvider);

    await biometricAuth.canEnableBiometric().then((canCheckBio) async {
      await biometricAuth.authenticate(canCheckBio).then((isAuthSuccess) {
        if (isAuthSuccess) {
          setState(() {
            _didAuthenticate = isAuthSuccess;
          });
        } else {
          showToast(kFailedToAuthenticate);
        }
      }).catchError((error) => showToast(error));
    }).catchError((error) => showToast(error));
  }

  @override
  void initState() {
    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SecureGate(
      blurr: 20,
      opacity: 0.6,
      child: _didAuthenticate ? widget.child : Container(),
      lockedBuilder: (context, secureNotifier) {
        if (_didAuthenticate) {
          secureNotifier.unlock();
        } else {
          secureNotifier.lock();
        }

        return Container(
          height: size.height,
          width: double.infinity,
          color: kBlueNavyColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: LottieWidget(
                  lottie: 'assets/lottie/biometric.json',
                  repeat: true,
                ),
              ),
              Container(
                width: size.width * 0.6,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Unlock',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      onPressed: () => authenticate(),
                    ),
                    SizedBox(height: size.height * 0.01),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Logout',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      onPressed: () =>
                          buildLogoutDialog(context, secureNotifier),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        );
      },
    );
  }

  Future buildLogoutDialog(
      BuildContext context, SecureApplicationController secureNotifier) {
    final confirmationDialog = ConfirmationDialog();
    final targetedPlatform = TargetedPlatform();

    void logout() {
      secureNotifier.unlock();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogoutScreen()),
      );
    }

    return showModal(
      context: context,
      builder: (context) {
        return targetedPlatform.isIOS()
            ? confirmationDialog.iOSAlertDialog(
                context, kLogOutAlertDialog, logout, 'Logout')
            : confirmationDialog.androidAlertDialog(
                context, kLogOutAlertDialog, logout, 'Logout');
      },
    );
  }
}
