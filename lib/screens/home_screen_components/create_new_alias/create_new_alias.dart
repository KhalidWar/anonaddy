import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account_model.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/loading_indicator.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alias_domain_selection.dart';
import 'alias_format_selection.dart';
import 'create_alias_recipient_selection.dart';

class CreateNewAlias extends StatefulWidget {
  const CreateNewAlias({Key? key, required this.account}) : super(key: key);
  final Account account;

  @override
  _CreateNewAliasState createState() => _CreateNewAliasState();
}

class _CreateNewAliasState extends State<CreateNewAlias> {
  final _localPartFormKey = GlobalKey<FormState>();

  String _description = '';
  String _localPart = '';

  String? aliasDomain;
  String? aliasFormat;

  String? defaultAliasDomain;
  String? defaultAliasFormat;

  bool isAliasDomainError = false;
  bool isAliasFormatError = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, watch, _) {
        final domainOptionsState = watch(domainOptionsStateNotifier);

        switch (domainOptionsState.status) {
          case DomainOptionsStatus.loading:
            return Container(
              height: size.height * 0.5,
              child: LoadingIndicator(),
            );

          case DomainOptionsStatus.loaded:
            defaultAliasDomain =
                domainOptionsState.domainOptions!.defaultAliasDomain;
            defaultAliasFormat =
                domainOptionsState.domainOptions!.defaultAliasFormat;

            return crateAliasWidget(domainOptionsState);

          case DomainOptionsStatus.failed:
            final error = domainOptionsState.errorMessage;
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              label: error.toString(),
              lottieHeight: MediaQuery.of(context).size.height * 0.2,
            );
        }
      },
    );
  }

  Widget crateAliasWidget(DomainOptionsState domainOptionsState) {
    final size = MediaQuery.of(context).size;

    final createAliasText =
        'Other aliases e.g. alias@${widget.account.username}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    Future<void> createNewAlias(String aliasDomain, aliasFormat) async {
      await context
          .read(aliasStateManagerProvider)
          .createNewAlias(_description, aliasDomain, aliasFormat, _localPart);
      Navigator.pop(context);
    }

    //todo Clean up this mess!!
    Future<void> createAlias() async {
      final isDomainNull = aliasDomain == null &&
          domainOptionsState.domainOptions!.defaultAliasDomain == null;
      final isFormatNull = aliasFormat == null &&
          domainOptionsState.domainOptions!.defaultAliasFormat == null;

      if (!isDomainNull) {
        if (!isFormatNull) {
          if (aliasFormat == kCustom) {
            if (_localPartFormKey.currentState!.validate()) {
              await createNewAlias(
                aliasDomain ?? defaultAliasDomain!,
                aliasFormat ?? defaultAliasFormat!,
              );
            }
          } else {
            await createNewAlias(
              aliasDomain ?? defaultAliasDomain!,
              aliasFormat ?? defaultAliasFormat!,
            );
          }
        } else {
          setState(() {
            isAliasFormatError = true;
          });
        }
      } else {
        setState(() {
          isAliasDomainError = true;
        });
      }
    }

    return Consumer(
      builder: (context, watch, _) {
        final aliasStateProvider = watch(aliasStateManagerProvider);
        final isLoading = aliasStateProvider.isToggleLoading;
        aliasDomain = aliasStateProvider.aliasDomain;
        aliasFormat = aliasStateProvider.aliasFormat;

        List<String> getAliasFormatList() {
          if (aliasStateProvider.sharedDomains.contains(aliasDomain)) {
            if (widget.account.subscription == kFreeSubscription) {
              return aliasStateProvider.freeTierWithSharedDomain;
            } else {
              return aliasStateProvider.paidTierWithSharedDomain;
            }
          } else {
            if (widget.account.subscription == kFreeSubscription) {
              return aliasStateProvider.freeTierNoSharedDomain;
            } else {
              return aliasStateProvider.paidTierNoSharedDomain;
            }
          }
        }

        if (aliasDomain == null) aliasDomain = defaultAliasDomain;
        if (aliasFormat == null) aliasFormat = defaultAliasFormat;

        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetHeader(headerLabel: kCreateNewAlias),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(createAliasText),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onChanged: (input) => _description = input,
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: kDescriptionFieldHint,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      if (aliasFormat == kCustom)
                        Column(
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Form(
                              key: _localPartFormKey,
                              child: TextFormField(
                                onChanged: (input) => _localPart = input,
                                validator: (input) => context
                                    .read(formValidator)
                                    .validateLocalPart(input!),
                                textInputAction: TextInputAction.next,
                                decoration: kTextFormFieldDecoration.copyWith(
                                  hintText: kLocalPartFieldHint,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: size.height * 0.01),
                      aliasDomainFormatDropdown(
                        context: context,
                        title: 'Alias Domain',
                        label: aliasDomain ?? kSelectAliasDomain,
                        isError: isAliasDomainError,
                        child: AliasDomainSelection(
                          aliasFormatList: getAliasFormatList(),
                          domainOptions: domainOptionsState.domainOptions!,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      aliasDomainFormatDropdown(
                        context: context,
                        title: 'Alias Format',
                        label: aliasFormat == null
                            ? kSelectAliasFormat
                            : context
                                .read(nicheMethods)
                                .correctAliasString(aliasFormat!),
                        isError: isAliasFormatError,
                        child: AliasFormatSelection(
                            aliasFormatList: getAliasFormatList()),
                      ),
                      if (aliasFormat == kCustom)
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
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: isLoading
                        ? context
                            .read(customLoadingIndicator)
                            .customLoadingIndicator()
                        : Text(kCreateAlias),
                    onPressed: isLoading ? () {} : () => createAlias(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget aliasDomainFormatDropdown(
      {required BuildContext context,
      required String title,
      required String label,
      required bool isError,
      required Widget child}) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      child: Container(
        color: isError ? Colors.red : null,
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
      onTap: () {
        isAliasDomainError = false;
        isAliasFormatError = false;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
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
