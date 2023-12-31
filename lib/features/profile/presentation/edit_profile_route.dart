import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../application/provider_profiles.dart';
import '../../snacks/snacks.dart';
import '../../../widgets/info_dialog.dart';
import '../../../widgets/confirm_dialog.dart';

/// Route for editing a profile
/// {@category Profile}
class EditProfileRoute extends StatefulWidget {
  const EditProfileRoute({super.key});

  @override
  State<EditProfileRoute> createState() => _EditProfileRouteState();
}

/// State for [EditProfileRoute]
class _EditProfileRouteState extends State<EditProfileRoute> {
  late final ProviderProfiles providerProfiles;
  late final AppLocalizations locals;
  final profileNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ibanController = TextEditingController();
  final targetController = TextEditingController();

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      final selectedProfile = providerProfiles.selectedProfile;
      profileNameController.text = selectedProfile!.profileName;
      firstNameController.text = selectedProfile.firstName;
      lastNameController.text = selectedProfile.lastName;
      ibanController.text = selectedProfile.iban;
      targetController.text = selectedProfile.target;
      locals = AppLocalizations.of(context)!;
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    profileNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ibanController.dispose();
    targetController.dispose();
    super.dispose();
  }

  /// Edit a profile using current values from the UI
  _saveProfile({required AppLocalizations locals}) async {
    if (profileNameController.text.trim().isEmpty ||
        firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        targetController.text.trim().isEmpty ||
        ibanController.text.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return InfoDialg(
              child: Text(locals.addProfileRouteNoEmptyFields),
            );
          });
      return;
    }
    if (ibanController.text.trim() != providerProfiles.selectedProfile!.iban) {
      final confirmation = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              child: Column(
                children: [
                  Text(
                    locals.addProfileRouteIBAN,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    ibanController.text.trim(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
            );
          });
      if (confirmation == null) return;
      if (!confirmation) return;
    }
    await providerProfiles.editProfile(
      id: providerProfiles.selectedProfile!.id,
      profileName: profileNameController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      // TODO Check iban
      iban: ibanController.text.trim(),
      target: targetController.text.trim(),
    );
    providerProfiles.selectProfile(id: providerProfiles.selectedProfile!.id);

    if (context.mounted) {
      sendSnack(
        context: context,
        content: locals.editProfileRouteSuccessMessage,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.editProfileRouteTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  controller: profileNameController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteProfileName),
                    hintText: locals.addProfileRouteProfileNameHint,
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteFirstName),
                    hintText: 'Ben, Jake, Rose, Sophie...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteLastName),
                    hintText: 'Anderson, Patel, Smith...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: targetController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteReference),
                    hintText: 'Korttelikylä, Asuva, Harju...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: ibanController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteIBAN),
                    hintText: 'FI83 4978 8259 0005 97...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(locals.cancel),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _saveProfile(locals: locals);
                          },
                          child: Text(locals.save),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                    onPressed: () async {
                      final confirmation = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialog(
                              child: Text(
                                locals.editProfileRouteConfirmDelete,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            );
                          });
                      if (confirmation == null) return;
                      if (!confirmation) return;
                      await providerProfiles
                          .deleteProfile(providerProfiles.selectedProfile!.id);

                      if (context.mounted) {
                        Navigator.of(context)
                            .pop(providerProfiles.selectedProfile?.id);
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        locals.delete,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
