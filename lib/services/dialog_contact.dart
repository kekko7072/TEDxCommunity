import 'imports.dart';
import 'package:flutter/cupertino.dart';

class SelectTypeOfContact extends StatefulWidget {
  final bool firstContact;
  final UserData userData;
  final Speaker speaker;
  final String? speakerID;
  final String? speakerPSSWD;

  const SelectTypeOfContact({
    super.key,
    required this.firstContact,
    required this.userData,
    required this.speaker,
    this.speakerID,
    this.speakerPSSWD,
  });

  @override
  State<SelectTypeOfContact> createState() => _SelectTypeOfContactState();
}

class _SelectTypeOfContactState extends State<SelectTypeOfContact> {
  String licenseId = '';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        AppLocalizations.of(context)!.doYouWantToMoveSpeakerToContacted,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Style.textColor(context),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: CupertinoColors.destructiveRed),
            )),
        TextButton(
          onPressed: () async {
            if (widget.firstContact) {
              await DatabaseSpeaker(id: widget.speaker.id, licenseId: licenseId)
                  .updateManagementStep(step: 1);

              await DatabaseSpeaker(id: widget.speaker.id, licenseId: licenseId)
                  .updateProgress(progress: Progress.contacted)
                  .then((_) {
                EasyLoading.showToast(AppLocalizations.of(context)!.contacted,
                    duration: const Duration(milliseconds: kDurationToast),
                    dismissOnTap: true,
                    toastPosition: EasyLoadingToastPosition.bottom);
              });
            } else {
              Clipboard.setData(ClipboardData(
                      text:
                          '${AppLocalizations.of(context)!.speakerId}: ${widget.speakerID!.substring(0, 5)} | ${AppLocalizations.of(context)!.code}: ${widget.speakerPSSWD}'))
                  .then((_) {
                EasyLoading.showToast(AppLocalizations.of(context)!.copied,
                    duration: const Duration(seconds: 2),
                    dismissOnTap: true,
                    toastPosition: EasyLoadingToastPosition.bottom);
              });
            }
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.confirm,
            style: const TextStyle(
                color: CupertinoColors.activeGreen, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
