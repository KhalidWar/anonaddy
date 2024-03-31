import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.child,
    required this.footerOnPress,
  });

  final Widget child;
  final Function() footerOnPress;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      child: Container(
        height: size.height * 0.65,
        width: size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'AddyManager',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const Divider(thickness: 2, indent: 100, endIndent: 100),
              ],
            ),
            child,
            SizedBox(
              height: 48,
              width: double.infinity,
              child: PlatformButton(
                key: const Key('loginFooterLoginButton'),
                onPress: footerOnPress,
                child: Consumer(
                  builder: (context, ref, _) {
                    final authAsync = ref.watch(authStateNotifier);
                    return authAsync.when(
                      data: (authState) {
                        return authState.loginLoading
                            ? const CircularProgressIndicator(
                                key: Key('loginFooterLoginButtonLoading'),
                              )
                            : Text(
                                'Log in',
                                key: const Key('loginFooterLoginButtonLabel'),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              );
                      },
                      error: (_, __) => const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
