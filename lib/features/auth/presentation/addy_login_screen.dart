import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddyLoginScreen extends ConsumerWidget {
  const AddyLoginScreen({super.key});

  static const routeName = 'loginScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: AppTheme.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        key: const Key('loginScreenScaffold'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.howToGetAccessToken,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Text(AppStrings.howToGetAccessToken1),
              const Text(AppStrings.howToGetAccessToken2),
              const Text(AppStrings.howToGetAccessToken3),
              const Text(AppStrings.howToGetAccessToken4),
              const Text(AppStrings.howToGetAccessToken5),
              const SizedBox(height: 8),
              Text(
                AppStrings.accessTokenSecurityNotice,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PlatformButton(
                  key: const Key('loginFooterLoginButton'),
                  onPress: () async {
                    final clipboardText =
                        await NicheMethod.pasteFromClipboard();
                    if (clipboardText == null || clipboardText.isEmpty) {
                      await Utilities.showToast(ToastMessage.failedToCopy);
                      return;
                    }

                    await ref
                        .read(authStateNotifier.notifier)
                        .loginWithAccessToken(kAuthorityURL, clipboardText)
                        .whenComplete(() => Navigator.of(context).pop());
                  },
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
                                  'Log in with copied Access Token',
                                  key: const Key('loginFooterLoginButtonLabel'),
                                  style: Theme.of(context).textTheme.labelLarge,
                                );
                        },
                        error: (_, __) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
