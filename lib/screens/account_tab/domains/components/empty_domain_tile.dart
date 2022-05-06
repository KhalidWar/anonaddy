import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class EmptyDomainTile extends StatelessWidget {
  const EmptyDomainTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Text(
          AppStrings.noDomainsFound,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
