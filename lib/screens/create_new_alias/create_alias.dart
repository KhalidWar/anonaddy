import 'package:anonaddy/screens/create_new_alias/components/recipients_dropdown.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alias_domain_selection.dart';
import 'alias_format_selection.dart';
import 'alias_recipient_selection.dart';
import 'components/domain_format_dropdown.dart';
import 'components/local_part_input.dart';

class CreateAlias extends StatelessWidget {
  const CreateAlias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, watch, _) {
        final createAliasState = watch(createAliasStateNotifier);

        void createAlias() {
          /// initiate create alias method
          context
              .read(createAliasStateNotifier.notifier)
              .createNewAlias()

              /// Dismiss sheet if alias is created
              .then((value) => Navigator.pop(context))

              /// Errors are shown as Toast Messages. This is only to
              /// stop framework from throwing errors.
              .catchError((error) => null);
        }

        return ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          physics: NeverScrollableScrollPhysics(),
          children: [
            BottomSheetHeader(headerLabel: kCreateNewAlias),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    createAliasState.headerText!,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (input) => context
                        .read(createAliasStateNotifier.notifier)
                        .setDescription(input),
                    decoration: kTextFormFieldDecoration.copyWith(
                      hintText: kDescriptionFieldHint,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  if (createAliasState.aliasFormat == kCustom)
                    const LocalPartInput(),
                  SizedBox(height: size.height * 0.01),
                  DomainFormatDropdown(
                    title: 'Alias Domain',
                    label: createAliasState.aliasDomain!,
                    onPress: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(kBottomSheetBorderRadius),
                          ),
                        ),
                        builder: (context) => const AliasDomainSelection(),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  DomainFormatDropdown(
                    title: 'Alias Format',
                    label: NicheMethod.correctAliasString(
                        createAliasState.aliasFormat!),
                    onPress: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(kBottomSheetBorderRadius),
                          ),
                        ),
                        builder: (context) => const AliasFormatSelection(),
                      );
                    },
                  ),
                  if (createAliasState.aliasFormat == kCustom)
                    Text(
                      kCreateAliasCustomFieldNote,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  SizedBox(height: size.height * 0.02),
                  RecipientsDropdown(
                    onPress: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(kBottomSheetBorderRadius)),
                        ),
                        builder: (context) => const AliasRecipientSelection(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: PlatformButton(
                child: createAliasState.isLoading!
                    ? const PlatformLoadingIndicator()
                    : const Text(
                        kCreateAlias,
                        style: TextStyle(color: Colors.black),
                      ),
                onPress:
                    createAliasState.isLoading! ? () {} : () => createAlias(),
              ),
            ),
            if (PlatformAware.isIOS()) SizedBox(height: size.height * 0.03),
          ],
        );
      },
    );
  }
}
