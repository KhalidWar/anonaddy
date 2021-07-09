import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/loading_indicator.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alias_domain_selection.dart';
import 'alias_format_selection.dart';
import 'create_alias_recipient_selection.dart';

class CreateNewAlias extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptionsAsync = watch(domainOptionsProvider);
    final size = MediaQuery.of(context).size;
    final customLoading = CustomLoadingIndicator().customLoadingIndicator();

    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isToggleLoading;
    final descFieldController = aliasStateProvider.descFieldController;
    final customFieldController = aliasStateProvider.customFieldController;
    String aliasDomain = aliasStateProvider.aliasDomain;
    String aliasFormat = aliasStateProvider.aliasFormat;

    final userModel = context.read(accountStreamProvider).data.value;
    final subscription = userModel.subscription;
    final createAliasText =
        'Other aliases e.g. alias@${userModel.username ?? 'username'}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    List<String> getAliasFormatList() {
      if (aliasStateProvider.sharedDomains.contains(aliasDomain)) {
        if (subscription == kFreeSubscription) {
          return aliasStateProvider.freeTierWithSharedDomain;
        } else {
          return aliasStateProvider.paidTierWithSharedDomain;
        }
      } else {
        if (subscription == kFreeSubscription) {
          return aliasStateProvider.freeTierNoSharedDomain;
        } else {
          return aliasStateProvider.paidTierNoSharedDomain;
        }
      }
    }

    Future<void> createAliasButtonOnPress(DomainOptions domainOptions) async {
      final isDomainNull =
          aliasDomain == null && domainOptions.defaultAliasDomain == null;
      final isFormatNull =
          aliasFormat == null && domainOptions.defaultAliasFormat == null;

      if (!isDomainNull) {
        if (!isFormatNull) {
          await aliasStateProvider.createNewAlias(
            context,
            descFieldController.text.trim(),
            aliasDomain ?? domainOptions.defaultAliasDomain,
            aliasFormat ?? domainOptions.defaultAliasFormat,
            customFieldController.text.trim(),
          );
        } else {
          print('Alias Format cannot be null');
        }
      } else {
        print('Alias Domain cannot be null');
      }
    }

    return domainOptionsAsync.when(
      loading: () => LoadingIndicator(),
      data: (domainOptions) {
        if (aliasDomain == null) aliasDomain = domainOptions.defaultAliasDomain;
        if (aliasFormat == null) aliasFormat = domainOptions.defaultAliasFormat;

        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetHeader(headerLabel: 'Create New Alias'),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(createAliasText),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: descFieldController,
                        textInputAction: TextInputAction.next,
                        decoration: kTextFormFieldDecoration.copyWith(
                            hintText: kDescriptionFieldHint),
                      ),
                      SizedBox(height: size.height * 0.01),
                      if (aliasFormat == kCustom)
                        Form(
                          key: aliasStateProvider.customFormKey,
                          child: TextFormField(
                            controller: customFieldController,
                            validator: (input) =>
                                FormValidator().validateLocalPart(input),
                            textInputAction: TextInputAction.next,
                            decoration: kTextFormFieldDecoration.copyWith(
                                hintText: kLocalPartFieldHint),
                          ),
                        ),
                      SizedBox(height: size.height * 0.01),
                      aliasDomainFormatDropdown(
                        context: context,
                        title: kAliasDomain,
                        label: aliasDomain ?? kChooseAliasDomain,
                        child: AliasDomainSelection(
                          aliasFormatList: getAliasFormatList(),
                          domainOptions: domainOptions,
                        ),
                      ),
                      aliasDomainFormatDropdown(
                        context: context,
                        title: kAliasFormat,
                        label: aliasFormat == null
                            ? kChooseAliasFormat
                            : aliasStateProvider
                                .correctAliasString(aliasFormat),
                        child: AliasFormatSelection(
                          aliasFormatList: getAliasFormatList(),
                        ),
                      ),
                      if (aliasFormat == kCustom)
                        Text('Note: not available on shared domains'),
                      SizedBox(height: size.height * 0.02),
                      recipientsDropdown(context)
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: isLoading ? customLoading : Text('Create Alias'),
                    onPressed: isLoading
                        ? () {}
                        : () => createAliasButtonOnPress(domainOptions),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrade) {
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: error,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
        );
      },
    );
  }

  Widget aliasDomainFormatDropdown(
      {BuildContext context, String title, String label, Widget child}) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(kBottomSheetBorderRadius),
            ),
          ),
          builder: (context) => child,
        );
      },
    );
  }

  Widget recipientsDropdown(BuildContext context) {
    final createAliasRecipients =
        context.read(aliasStateManagerProvider).createAliasRecipients;
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
                        style: Theme.of(context).textTheme.headline6,
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
