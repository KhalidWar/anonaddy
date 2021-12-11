import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account_model.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alias_domain_selection.dart';
import 'alias_format_selection.dart';
import 'create_alias_recipient_selection.dart';

class CreateNewAlias extends StatefulWidget {
  CreateNewAlias({Key? key, required this.account}) : super(key: key);
  final Account account;

  @override
  State<CreateNewAlias> createState() => _CreateNewAliasState();
}

class _CreateNewAliasState extends State<CreateNewAlias> {
  final _localPartFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, watch, _) {
        final domainOptionsState = watch(domainOptionsStateNotifier);

        switch (domainOptionsState.status) {
          case DomainOptionsStatus.loading:
            return Center(child: PlatformLoadingIndicator());

          case DomainOptionsStatus.loaded:
            final createAliasState = watch(createAliasNotifier);
            return buildListView(createAliasState, domainOptionsState);

          case DomainOptionsStatus.failed:
            final error = domainOptionsState.errorMessage;
            return Container(
              height: size.height * 0.5,
              child: LottieWidget(
                lottie: 'assets/lottie/errorCone.json',
                label: error,
                lottieHeight: MediaQuery.of(context).size.height * 0.2,
              ),
            );
        }
      },
    );
  }

  Widget buildListView(CreateAliasNotifier createAliasState,
      DomainOptionsState domainOptionsState) {
    final size = MediaQuery.of(context).size;
    final createAliasText =
        'Other aliases e.g. alias@${widget.account.username}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    final onPressNotifier = context.read(createAliasNotifier.notifier);

    Future createAlias() async {
      if (!createAliasState.isAliasDomainNull()) {
        if (!createAliasState.isAliasFormatNull()) {
          if (createAliasState.aliasFormat == kCustom) {
            if (_localPartFormKey.currentState!.validate()) {
              await onPressNotifier.createNewAlias();
              Navigator.pop(context);
            }
          } else {
            await onPressNotifier.createNewAlias();
            Navigator.pop(context);
          }
        } else {
          onPressNotifier.setAliasFormatError(true);
        }
      } else {
        onPressNotifier.setAliasDomainError(true);
      }
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
              Text(createAliasText),
              SizedBox(height: size.height * 0.01),
              TextFormField(
                textInputAction: TextInputAction.next,
                onChanged: (input) => onPressNotifier.setDescription(input),
                decoration: kTextFormFieldDecoration.copyWith(
                  hintText: kDescriptionFieldHint,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              if (createAliasState.aliasFormat == kCustom)
                buildLocalPartInput(context, onPressNotifier),
              SizedBox(height: size.height * 0.01),
              aliasDomainFormatDropdown(
                context: context,
                title: 'Alias Domain',
                label: createAliasState.aliasDomain ?? kSelectAliasDomain,
                isError: createAliasState.isAliasDomainError!,
                onPress: () {
                  onPressNotifier.setAliasDomainError(false);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(kBottomSheetBorderRadius),
                      ),
                    ),
                    builder: (context) => AliasDomainSelection(
                      domainOptions: domainOptionsState.domainOptions!,
                      setAliasDomain: (domain) {
                        onPressNotifier.setAliasDomain(domain);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: size.height * 0.01),
              aliasDomainFormatDropdown(
                context: context,
                title: 'Alias Format',
                label: createAliasState.aliasFormat == null
                    ? kSelectAliasFormat
                    : NicheMethod.correctAliasString(
                        createAliasState.aliasFormat!),
                isError: createAliasState.isAliasFormatError!,
                onPress: () {
                  onPressNotifier.setAliasFormatError(false);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(kBottomSheetBorderRadius),
                      ),
                    ),
                    builder: (context) => AliasFormatSelection(
                      setAliasFormat: (format) {
                        onPressNotifier.setAliasFormat(format);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              if (createAliasState.aliasFormat == kCustom)
                Text(
                  kCreateAliasCustomFieldNote,
                  style: Theme.of(context).textTheme.caption,
                ),
              SizedBox(height: size.height * 0.02),
              recipientsDropdown(context),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: PlatformButton(
            child: createAliasState.isLoading!
                ? PlatformLoadingIndicator()
                : Text(kCreateAlias, style: TextStyle(color: Colors.black)),
            onPress: createAliasState.isLoading! ? () {} : () => createAlias(),
          ),
        ),
        if (PlatformAware.isIOS()) SizedBox(height: size.height * 0.03),
      ],
    );
  }

  Widget buildLocalPartInput(
      BuildContext context, CreateAliasNotifier onPressNotifier) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Form(
          key: _localPartFormKey,
          child: TextFormField(
            onChanged: (input) => onPressNotifier.setLocalPart(input),
            validator: (input) =>
                context.read(formValidator).validateLocalPart(input!),
            textInputAction: TextInputAction.next,
            decoration: kTextFormFieldDecoration.copyWith(
              hintText: kLocalPartFieldHint,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget aliasDomainFormatDropdown(
      {required BuildContext context,
      required String title,
      required String label,
      required bool isError,
      required Function onPress}) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: 1,
        ),
        decoration: BoxDecoration(
          color: isError ? Colors.redAccent : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ],
        ),
      ),
      onTap: () => onPress(),
    );
  }

  Widget recipientsDropdown(BuildContext context) {
    final createAliasRecipients =
        context.read(createAliasNotifier).createAliasRecipients;
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recipients'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (createAliasRecipients.isEmpty)
                Text('Select recipient(s) (optional)')
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: createAliasRecipients.length,
                    itemBuilder: (context, index) {
                      final recipient = createAliasRecipients[index];
                      return Text(
                        recipient.email,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ],
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(kBottomSheetBorderRadius)),
        ),
        builder: (context) => CreateAliasRecipientSelection(),
      ),
    );
  }
}
