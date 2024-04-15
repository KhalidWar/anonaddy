import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutScreen extends ConsumerStatefulWidget {
  const LogoutScreen({super.key});

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
