import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DomainListTile extends StatelessWidget {
  const DomainListTile({
    super.key,
    required this.domain,
  });

  final Domain domain;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.dns_outlined),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain.domain),
                Text(
                  domain.hasDescription
                      ? domain.description!
                      : AppStrings.noDescription,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () => context.router.push(DomainScreenRoute(id: domain)),
    );
  }
}
