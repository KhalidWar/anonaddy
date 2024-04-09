import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPageImage extends StatelessWidget {
  const OnboardingPageImage({
    super.key,
    required this.svgPath,
  });

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      child: SvgPicture.asset(
        svgPath,
        height: 240,
      ),
    );
  }
}
