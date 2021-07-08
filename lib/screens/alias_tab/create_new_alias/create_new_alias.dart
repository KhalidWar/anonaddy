import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/loading_indicator.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alias_format_selection.dart';
import 'create_alias_recipient_selection.dart';

class CreateNewAlias extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptions = watch(domainOptionsProvider);
    final size = MediaQuery.of(context).size;
    final customLoading = CustomLoadingIndicator().customLoadingIndicator();

    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isToggleLoading;
    final descFieldController = aliasStateProvider.descFieldController;
    final customFieldController = aliasStateProvider.customFieldController;
    final customFormKey = aliasStateProvider.customFormKey;
    final correctAliasString = aliasStateProvider.correctAliasString;
    final sharedDomains = aliasStateProvider.sharedDomains;
    String aliasDomain = aliasStateProvider.aliasDomain;
    String aliasFormat = aliasStateProvider.aliasFormat;

    final userModel = context.read(accountStreamProvider).data.value;
    final subscription = userModel.subscription;
    final createAliasText =
        'Other aliases e.g. alias@${userModel.username ?? 'username'}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    int aliasDomainIndex = 0;
    int aliasFormatIndex = 0;

    List<String> getAliasFormatList() {
      if (sharedDomains.contains(aliasDomain)) {
        if (subscription == 'free') {
          return aliasStateProvider.freeTierWithSharedDomain;
        } else {
          return aliasStateProvider.paidTierWithSharedDomain;
        }
      } else {
        if (subscription == 'free') {
          return aliasStateProvider.freeTierNoSharedDomain;
        } else {
          return aliasStateProvider.paidTierNoSharedDomain;
        }
      }
    }

    void createAliasButtonOnPress(DomainOptions data) {
      final isDomainNull =
          aliasDomain == null && data.defaultAliasDomain == null;
      final isFormatNull =
          aliasFormat == null && data.defaultAliasFormat == null;

      if (!isDomainNull) {
        if (!isFormatNull) {
          aliasStateProvider.createNewAlias(
            context,
            descFieldController.text.trim(),
            aliasDomain ?? data.defaultAliasDomain,
            aliasFormat ?? data.defaultAliasFormat,
            customFieldController.text.trim(),
          );
        } else {
          print('Alias Format cannot be null');
        }
      } else {
        print('Alias Domain cannot be null');
      }
    }

    return domainOptions.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        if (aliasDomain == null) aliasDomain = data.defaultAliasDomain;
        if (aliasFormat == null) aliasFormat = data.defaultAliasFormat;

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
                          key: customFormKey,
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
                        onPress: () {
                          buildDomainSelection(
                              context,
                              data,
                              aliasDomainIndex,
                              aliasFormatIndex,
                              aliasFormat,
                              aliasStateProvider,
                              sharedDomains,
                              getAliasFormatList);
                        },
                      ),
                      aliasDomainFormatDropdown(
                        context: context,
                        title: kAliasFormat,
                        label: aliasFormat == null
                            ? kChooseAliasFormat
                            : correctAliasString(aliasFormat),
                        onPress: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(kBottomSheetBorderRadius),
                              ),
                            ),
                            builder: (context) {
                              return AliasFormatSelection(
                                aliasFormatList: getAliasFormatList(),
                              );
                            },
                          );
                        },
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
                        : () => createAliasButtonOnPress(data),
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
      {BuildContext context, String title, String label, Function onPress}) {
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
      onTap: onPress,
    );
  }

  Future buildDomainSelection(
      BuildContext context,
      DomainOptions data,
      int aliasDomainIndex,
      int aliasFormatIndex,
      String aliasFormat,
      AliasStateManager aliasStateProvider,
      List<String> sharedDomains,
      Function getAliasFormatList) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void setAliasDomain(DomainOptions domainOptions) {
      final selectedDomain = domainOptions.sharedDomainsList[aliasDomainIndex];
      aliasStateProvider.setAliasDomain = selectedDomain;
      if (domainOptions.defaultAliasFormat == null) {
        aliasFormat = null;
      } else {
        if (sharedDomains.contains(selectedDomain)) {
          aliasStateProvider.setAliasFormat =
              getAliasFormatList()[aliasFormatIndex];
        } else {
          aliasStateProvider.setAliasFormat = domainOptions.defaultAliasFormat;
        }
      }
    }

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return Column(
          children: [
            BottomSheetHeader(headerLabel: 'Select Alias Domain'),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                diameterRatio: 10,
                squeeze: 1,
                selectionOverlay: Container(),
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (index) {
                  aliasDomainIndex = index;
                },
                children: data.sharedDomainsList.map<Widget>((value) {
                  return Text(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Text('Done'),
                onPressed: () {
                  setAliasDomain(data);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
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
