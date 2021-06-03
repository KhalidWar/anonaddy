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

class CreateNewAlias extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptions = watch(domainOptionsProvider);
    final size = MediaQuery.of(context).size;
    final customLoading = CustomLoadingIndicator().customLoadingIndicator();

    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isToggleLoading;
    final createNewAlias = aliasStateProvider.createNewAlias;
    final descFieldController = aliasStateProvider.descFieldController;
    final customFieldController = aliasStateProvider.customFieldController;
    final customFormKey = aliasStateProvider.customFormKey;
    final correctAliasString = aliasStateProvider.correctAliasString;
    final sharedDomains = aliasStateProvider.sharedDomains;
    String aliasFormat = aliasStateProvider.aliasFormat;
    String aliasDomain = aliasStateProvider.aliasDomain;

    final freeTierNoSharedDomain = aliasStateProvider.freeTierNoSharedDomain;
    final freeTierWithSharedDomain =
        aliasStateProvider.freeTierWithSharedDomain;
    final paidTierNoSharedDomain = aliasStateProvider.paidTierNoSharedDomain;
    final paidTierWithSharedDomain =
        aliasStateProvider.paidTierWithSharedDomain;

    final userModel = context.read(accountStreamProvider).data.value;
    final subscription = userModel.subscription;
    final createAliasText =
        'Other aliases e.g. alias@${userModel.username ?? 'username'}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    List<DropdownMenuItem<String>> dropdownMenuItems() {
      if (sharedDomains.contains(aliasDomain)) {
        if (subscription == 'free') {
          return freeTierWithSharedDomain
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        } else {
          return paidTierWithSharedDomain
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        }
      } else {
        if (subscription == 'free') {
          return freeTierNoSharedDomain.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        } else {
          return paidTierNoSharedDomain.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        }
      }
    }

    void createAliasButtonOnPress(DomainOptions data) {
      if (aliasDomain != null && data.defaultAliasDomain != null ||
          aliasFormat != null && data.defaultAliasFormat != null) {
        createNewAlias(
          context,
          descFieldController.text.trim(),
          aliasDomain ?? data.defaultAliasDomain,
          aliasFormat ?? data.defaultAliasFormat,
          customFieldController.text.trim(),
        );
      }
    }

    void setsAliasDomain(String value, DomainOptions data) {
      aliasStateProvider.setAliasDomain = value;
      if (sharedDomains.contains(value)) {
        aliasStateProvider.setAliasFormat = kUUID;
      } else {
        aliasStateProvider.setAliasFormat = data.defaultAliasFormat;
      }
    }

    return domainOptions.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        if (aliasFormat == null) aliasFormat = data.defaultAliasFormat;
        if (aliasDomain == null) aliasDomain = data.defaultAliasDomain;

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
                            hintText: kDescriptionInputText),
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
                                hintText: kEnterLocalPart),
                          ),
                        ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Alias domain',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        isDense: true,
                        value: aliasDomain,
                        hint: Text(
                          '${data.defaultAliasDomain ?? 'Choose Alias Domain'}',
                        ),
                        items: data.sharedDomainsList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) =>
                            setsAliasDomain(value, data),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Alias format',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        isDense: true,
                        value: aliasFormat,
                        hint: Text(
                          correctAliasString(data.defaultAliasFormat) ??
                              'Choose Alias Format',
                        ),
                        items: dropdownMenuItems(),
                        onChanged: (String value) {
                          aliasStateProvider.setAliasFormat = value;
                        },
                      ),
                      if (aliasFormat == kCustom)
                        Text('Note: not available on shared domains'),
                      SizedBox(height: size.height * 0.02),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          child:
                              isLoading ? customLoading : Text('Create Alias'),
                          onPressed: isLoading
                              ? () {}
                              : () => createAliasButtonOnPress(data),
                        ),
                      ),
                    ],
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
}
