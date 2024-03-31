import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:flutter/material.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(20),
      child: const LottieWidget(
        lottie: LottieImages.comingSoon,
        repeat: true,
      ),
    );
  }
}
