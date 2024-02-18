import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/domains/presentation/domains_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class DomainListTile extends StatelessWidget {
  const DomainListTile({Key? key, required this.domain}) : super(key: key);
  final Domain domain;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.dns_outlined),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain.domain),
                const SizedBox(height: 2),
                Text(
                  domain.description.isEmpty
                      ? AppStrings.noDescription
                      : domain.description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          DomainsScreen.routeName,
          arguments: domain,
        );
      },
    );
  }
}
