import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainStateManager extends ChangeNotifier {
  DomainStateManager() {
    activeSwitchLoading = false;
    catchAllSwitchLoading = false;
    updateRecipientLoading = false;
  }

  late Domain domain;

  late bool _activeSwitchLoading;
  late bool _catchAllSwitchLoading;
  late bool _updateRecipientLoading;

  final createDomainFormKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();
  final _showToast = NicheMethod().showToast;

  bool get activeSwitchLoading => _activeSwitchLoading;
  bool get catchAllSwitchLoading => _catchAllSwitchLoading;
  bool get updateRecipientLoading => _updateRecipientLoading;

  set activeSwitchLoading(bool input) {
    _activeSwitchLoading = input;
    notifyListeners();
  }

  set catchAllSwitchLoading(bool input) {
    _catchAllSwitchLoading = input;
    notifyListeners();
  }

  set updateRecipientLoading(bool input) {
    _updateRecipientLoading = input;
    notifyListeners();
  }

  Future<void> toggleActivity(BuildContext context, String domainID) async {
    final domainProvider = context.read(domainServiceProvider);
    activeSwitchLoading = true;
    if (domain.active) {
      await domainProvider.deactivateDomain(domainID).then((data) {
        _showToast('Domain Deactivated Successfully!');
        domain.active = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      activeSwitchLoading = false;
    } else {
      await domainProvider.activateDomain(domainID).then((data) {
        domain.active = data.active;
        _showToast('Domain Activated Successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      activeSwitchLoading = false;
    }
  }

  Future<void> toggleCatchAll(BuildContext context, String domainID) async {
    final domainProvider = context.read(domainServiceProvider);
    catchAllSwitchLoading = true;
    if (domain.catchAll) {
      await domainProvider.deactivateCatchAll(domainID).then((data) {
        _showToast('Catch All Deactivated Successfully!');
        domain.catchAll = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    } else {
      await domainProvider.activateCatchAll(domainID).then((data) {
        domain.catchAll = data.catchAll;
        _showToast('Catch All Activated Successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    }
  }

  Future<void> createNewDomain(BuildContext context, String domain) async {
    if (createDomainFormKey.currentState!.validate()) {
      await context
          .read(domainServiceProvider)
          .createNewDomain(domain)
          .then((domain) {
        _showToast('domain added successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future editDescription(BuildContext context, domainID, description) async {
    if (descriptionFormKey.currentState!.validate()) {
      await context
          .read(domainServiceProvider)
          .editDomainDescription(domainID, description)
          .then((data) {
        Navigator.pop(context);
        domain.description = data.description;
        _showToast('Description updated successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future updateDomainDefaultRecipient(
      BuildContext context, domainID, recipientID) async {
    updateRecipientLoading = true;
    await context
        .read(domainServiceProvider)
        .updateDomainDefaultRecipient(domainID, recipientID)
        .then((updatedDomain) {
      updateRecipientLoading = false;
      domain.defaultRecipient = updatedDomain.defaultRecipient;
      notifyListeners();
      _showToast('Default recipient updated successfully!');
      Navigator.pop(context);
    }).catchError((error) {
      _showToast(error.toString());
      updateRecipientLoading = false;
    });
  }

  Future<void> deleteDomain(BuildContext context, String domainID) async {
    Navigator.pop(context);
    await context
        .read(domainServiceProvider)
        .deleteDomain(domainID)
        .then((domain) {
      Navigator.pop(context);
      _showToast('Domain deleted successfully!');
    }).catchError((error) {
      _showToast(error.toString());
    });
  }
}
