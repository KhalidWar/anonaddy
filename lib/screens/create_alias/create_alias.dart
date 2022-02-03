import 'package:anonaddy/screens/create_alias/components/recipients_dropdown.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'alias_domain_selection.dart';
import 'alias_format_selection.dart';
import 'alias_recipient_selection.dart';
import 'components/create_alias_card.dart';
import 'components/local_part_input.dart';

/// This is a deeply nested complex widget with multiple [BuildContext] that
/// controls a full screen iOS style bottom sheet.
/// Check out [modal_bottom_sheet] package's official example:
/// https://github.com/jamesblasco/modal_bottom_sheet/blob/master/example/lib/modals/modal_with_navigator.dart
class CreateAlias extends StatelessWidget {
  const CreateAlias({Key? key}) : super(key: key);

  /// Creates alias with selected parameters.
  void createAlias(BuildContext rootContext) {
    /// initiate create alias method
    rootContext
        .read(createAliasStateNotifier.notifier)
        .createNewAlias()

        /// [rootContext] is used to dismiss the whole sheet
        /// after alias is created.
        .then((value) => Navigator.pop(rootContext))

        /// Errors are shown as Toast Messages. This is only to
        /// stop framework from throwing errors.
        .catchError((error) => null);
  }

  /// Shows the bottom sheet to render child widget on.
  void displayModal(BuildContext rootContext, Widget child) {
    showModalBottomSheet(
      context: rootContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBottomSheetBorderRadius),
        ),
      ),
      builder: (context) => child,
    );
  }

  @override
  Widget build(BuildContext rootContext) {
    final isDark = Theme.of(rootContext).brightness == Brightness.dark;

    /// Base [Material] widget is required to display and nest other material widgets
    /// such as [TextFormField] inside [Cupertino] widgets.
    return Material(
      /// [Navigator] is used to navigate to other screens inside [CreateAlias]
      ///  without dismissing [CreateAlias] sheet.
      ///  NOTE: it's currently unused but there are plans for it.
      child: Navigator(
        onGenerateRoute: (_) {
          /// [MaterialPageRoute] is responsible for drawing routes.
          return MaterialPageRoute(
            builder: (materialPageRouteContext) {
              return Builder(
                builder: (builderContext) {
                  /// iOS style screen used as base widget.
                  return CupertinoPageScaffold(
                    /// iOS style header (top bar).
                    navigationBar: CupertinoNavigationBar(
                      /// [backgroundColor] not setting dark theme is a known bug.
                      /// https://github.com/flutter/flutter/issues/51899
                      backgroundColor: isDark ? Colors.black12 : Colors.white,
                      brightness: Brightness.dark,
                      leading: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(rootContext),
                      ),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: Text('Done'),
                        onPressed: () => createAlias(rootContext),
                      ),

                      middle: Text(
                        'Create New Alias',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),

                    /// This is the body of the sheet.
                    child: buildCreateAliasBody(builderContext, rootContext),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildCreateAliasBody(
      BuildContext builderContext, BuildContext rootContext) {
    final size = MediaQuery.of(rootContext).size;

    return Consumer(
      builder: (consumerContext, watch, _) {
        final createAliasState = watch(createAliasStateNotifier);

        return SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            controller: ModalScrollController.of(builderContext),
            children: [
              Text(
                createAliasState.headerText!,
                style: Theme.of(consumerContext).textTheme.caption,
              ),
              Divider(height: 20),
              CreateAliasCard(
                header: 'Description',
                subHeader:
                    'A unique word or two that describe alias. You can also search for aliases by their description.',
                showIcon: false,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onChanged: (input) => consumerContext
                      .read(createAliasStateNotifier.notifier)
                      .setDescription(input),
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: kDescriptionFieldHint,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              cardSpacer(size),
              if (createAliasState.aliasFormat == kCustom)
                Column(
                  children: [
                    const LocalPartInput(),
                    cardSpacer(size),
                  ],
                ),
              CreateAliasCard(
                header: 'Alias Domain',
                subHeader:
                    'A domain URL that appends alias email similar to ***@gmail.com.',
                child: Text(
                  createAliasState.aliasDomain!,
                  style: Theme.of(consumerContext)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                onPress: () {
                  displayModal(rootContext, AliasDomainSelection());
                },
              ),
              cardSpacer(size),
              CreateAliasCard(
                header: 'Alias Format',
                subHeader: '',
                child: Text(
                  NicheMethod.correctAliasString(createAliasState.aliasFormat!),
                  style: Theme.of(consumerContext)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                onPress: () {
                  displayModal(rootContext, AliasFormatSelection());
                },
              ),
              if (createAliasState.aliasFormat == kCustom)
                Text(
                  kCreateAliasCustomFieldNote,
                  style: Theme.of(consumerContext).textTheme.caption,
                ),
              cardSpacer(size),
              RecipientsDropdown(
                onPress: () {
                  displayModal(rootContext, AliasRecipientSelection());
                },
              ),
              cardSpacer(size),
              Container(
                width: double.infinity,
                child: PlatformButton(
                  child: createAliasState.isLoading!
                      ? const PlatformLoadingIndicator()
                      : const Text(
                          kCreateAlias,
                          style: TextStyle(color: Colors.black),
                        ),
                  onPress: createAliasState.isLoading!
                      ? () {}
                      : () => createAlias(rootContext),
                ),
              ),
              cardSpacer(size),
              cardSpacer(size),
            ],
          ),
        );
      },
    );
  }

  Widget cardSpacer(Size size) {
    return SizedBox(height: size.height * 0.02);
  }
}
