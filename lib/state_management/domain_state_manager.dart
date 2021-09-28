import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DomainStateManager extends ChangeNotifier {
  DomainStateManager({required this.domainService, required this.showToast}) {
    activeSwitchLoading = false;
    catchAllSwitchLoading = false;
    updateRecipientLoading = false;
  }

  final DomainsService domainService;
  final Function showToast;

  late bool _activeSwitchLoading;
  late bool _catchAllSwitchLoading;
  late bool _updateRecipientLoading;

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

  Future<void> toggleActivity(BuildContext context, Domain domain) async {
    activeSwitchLoading = true;
    if (domain.active) {
      await domainService.deactivateDomain(domain.id).then((data) {
        domain.active = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      activeSwitchLoading = false;
    } else {
      await domainService.activateDomain(domain.id).then((data) {
        domain.active = data.active;
      }).catchError((error) {
        showToast(error.toString());
      });
      activeSwitchLoading = false;
    }
  }

  Future<void> toggleCatchAll(BuildContext context, Domain domain) async {
    catchAllSwitchLoading = true;
    if (domain.catchAll) {
      await domainService.deactivateCatchAll(domain.id).then((data) {
        domain.catchAll = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    } else {
      await domainService.activateCatchAll(domain.id).then((data) {
        domain.catchAll = data.catchAll;
      }).catchError((error) {
        showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    }
  }

  Future<void> createNewDomain(BuildContext context, String domain) async {
    final createDomainFormKey = GlobalKey<FormState>();
    if (createDomainFormKey.currentState!.validate()) {
      await domainService.createNewDomain(domain).then((domain) {
        showToast('domain added successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        showToast(error.toString());
      });
    }
  }

  Future editDescription(
      BuildContext context, Domain domain, description) async {
    await domainService
        .editDomainDescription(domain.id, description)
        .then((data) {
      Navigator.pop(context);
      domain.description = data.description;
      showToast('Description updated successfully!');
    }).catchError((error) {
      showToast(error.toString());
    });
  }

  Future updateDomainDefaultRecipient(
      BuildContext context, Domain domain, recipientID) async {
    updateRecipientLoading = true;
    await domainService
        .updateDomainDefaultRecipient(domain.id, recipientID)
        .then((updatedDomain) {
      updateRecipientLoading = false;
      domain.defaultRecipient = updatedDomain.defaultRecipient;
      notifyListeners();
      showToast('Default recipient updated successfully!');
      Navigator.pop(context);
    }).catchError((error) {
      showToast(error.toString());
      updateRecipientLoading = false;
    });
  }

  Future<void> deleteDomain(BuildContext context, Domain domain) async {
    Navigator.pop(context);
    await domainService.deleteDomain(domain.id).then((domain) {
      Navigator.pop(context);
      showToast('Domain deleted successfully!');
    }).catchError((error) {
      showToast(error.toString());
    });
  }
}
