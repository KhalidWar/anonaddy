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
  int aliasDomainIndex;
  int aliasFormatIndex;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptions = watch(domainOptionsProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customLoading = CustomLoadingIndicator().customLoadingIndicator();

    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isToggleLoading;
    final createNewAlias = aliasStateProvider.createNewAlias;
    final descFieldController = aliasStateProvider.descFieldController;
    final customFieldController = aliasStateProvider.customFieldController;
    final customFormKey = aliasStateProvider.customFormKey;
    final correctAliasString = aliasStateProvider.correctAliasString;
    final sharedDomains = aliasStateProvider.sharedDomains;
    String aliasDomain = aliasStateProvider.aliasDomain;
    String aliasFormat = aliasStateProvider.aliasFormat;

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

    List<String> getAliasFormatList() {
      if (sharedDomains.contains(aliasDomain)) {
        if (subscription == 'free') {
          return freeTierWithSharedDomain;
        } else {
          return paidTierWithSharedDomain;
        }
      } else {
        if (subscription == 'free') {
          return freeTierNoSharedDomain;
        } else {
          return paidTierNoSharedDomain;
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
          createNewAlias(
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

    void setAliasDomain(DomainOptions domainOptions) {
      final selectedDomain = domainOptions.sharedDomainsList[aliasDomainIndex];
      print(selectedDomain);
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
                      InkWell(
                        child: Container(
                          height: size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(aliasDomain ?? 'Choose Alias Domain',
                                  style: TextStyle(fontSize: 18)),
                              Icon(Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      kBottomSheetBorderRadius)),
                            ),
                            builder: (context) {
                              aliasDomainIndex = 0;
                              return Column(
                                children: [
                                  BottomSheetHeader(
                                      headerLabel: 'Select Alias Domain'),
                                  Container(
                                    height: size.height * 0.4,
                                    child: CupertinoPicker(
                                      itemExtent: 50,
                                      diameterRatio: 10,
                                      squeeze: 1,
                                      selectionOverlay: Container(),
                                      backgroundColor: Colors.transparent,
                                      onSelectedItemChanged: (index) {
                                        aliasDomainIndex = index;
                                      },
                                      children: data.sharedDomainsList
                                          .map<Widget>((value) {
                                        return Text(
                                          value,
                                          style: TextStyle(
                                            color: isDark ? Colors.white : null,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(),
                                    child: Text('Done'),
                                    onPressed: () {
                                      setAliasDomain(data);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Alias format',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      InkWell(
                        child: Container(
                          height: size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                aliasFormat == null
                                    ? 'Choose Alias Format'
                                    : correctAliasString(aliasFormat),
                                style: TextStyle(fontSize: 18),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      kBottomSheetBorderRadius)),
                            ),
                            builder: (context) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BottomSheetHeader(
                                      headerLabel: 'Select Alias Format'),
                                  Expanded(
                                    child: CupertinoPicker(
                                      itemExtent: 50,
                                      diameterRatio: 10,
                                      squeeze: 1,
                                      selectionOverlay: Container(),
                                      useMagnifier: false,
                                      backgroundColor: Colors.transparent,
                                      onSelectedItemChanged: (index) {
                                        aliasFormatIndex = index;
                                      },
                                      children: getAliasFormatList()
                                          .map<Widget>((value) {
                                        return Text(
                                          correctAliasString(value),
                                          style: TextStyle(
                                            color: isDark ? Colors.white : null,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      child: Text('Done'),
                                      onPressed: () {
                                        aliasStateProvider.setAliasFormat =
                                            getAliasFormatList()[
                                                aliasFormatIndex ?? 0];
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
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
