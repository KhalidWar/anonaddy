import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_alias_card.dart';

class LocalPartInput extends StatelessWidget {
  const LocalPartInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateAliasCard(
      header: 'Local Part',
      subHeader: '',
      showIcon: false,
      child: TextFormField(
        onChanged: (input) =>
            context.read(createAliasStateNotifier.notifier).setLocalPart(input),
        textInputAction: TextInputAction.next,
        decoration: kTextFormFieldDecoration.copyWith(
          hintText: kLocalPartFieldHint,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
