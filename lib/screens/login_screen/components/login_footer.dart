import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/notifiers/authorization/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({Key? key, required this.onPress}) : super(key: key);
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: size.height * 0.09,
      width: size.width,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : const Color(0xFFF5F7FA),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: ElevatedButton(
        key: const Key('loginFooterLoginButton'),
        style: ElevatedButton.styleFrom(),
        onPressed: onPress,
        child: Consumer(
          builder: (context, ref, _) {
            final authState = ref.watch(authStateNotifier);
            return authState.loginLoading
                ? const CircularProgressIndicator(
                    key: Key('loginFooterLoginButtonLoading'),
                    backgroundColor: AppColors.primaryColor,
                  )
                : Text(
                    'Log in',
                    key: const Key('loginFooterLoginButtonLabel'),
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.black),
                  );
          },
        ),
      ),
    );
  }
}
