import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/toast_message.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddyLogin extends ConsumerStatefulWidget {
  const AddyLogin({super.key});

  @override
  ConsumerState<AddyLogin> createState() => _AddyLoginScreenState();
}

class _AddyLoginScreenState extends ConsumerState<AddyLogin> {
  bool showLoading = false;

  void toggleLoading(bool isLoading) {
    setState(() {
      showLoading = isLoading;
    });
  }

  Future<void> login() async {
    toggleLoading(true);

    final clipboardText = await Utilities.pasteFromClipboard();
    if (clipboardText == null || clipboardText.isEmpty) {
      await Utilities.showToast(ToastMessage.failedToCopy);
      toggleLoading(false);
      return;
    }

    await ref
        .read(authNotifierProvider.notifier)
        .loginWithAccessToken(kAuthorityURL, clipboardText)
        .then((_) => toggleLoading(false));
  }

  @override
  Widget build(BuildContext context) {
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
                  onPress: login,
                  child: showLoading
                      ? const CircularProgressIndicator(
                          key: Key('loginFooterLoginButtonLoading'),
                        )
                      : Text(
                          'Log in with copied Access Token',
                          key: const Key('loginFooterLoginButtonLabel'),
                          style: Theme.of(context).textTheme.labelLarge,
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
