import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutScreen extends ConsumerStatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  static const routeName = 'logoutScreen';

  @override
  ConsumerState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends ConsumerState<LogoutScreen> {
  Future<void> logout() async {
    await ref.read(authStateNotifier.notifier).logout(context);
  }

  @override
  void initState() {
    super.initState();
    logout();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
