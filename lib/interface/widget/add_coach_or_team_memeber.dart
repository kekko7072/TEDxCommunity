import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class AddCoachOrTeamMember extends StatefulWidget {
  final bool isSelectCoach;
  final Speaker speakerData;

  const AddCoachOrTeamMember({
    super.key,
    required this.isSelectCoach,
    required this.speakerData,
  });

  @override
  AddCoachOrTeamMemberState createState() => AddCoachOrTeamMemberState();
}

class AddCoachOrTeamMemberState extends State<AddCoachOrTeamMember> {
  int selectedValue = 0;
  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>?>(
        stream: widget.isSelectCoach
            ? DatabaseUser(licenseId: licenseId).streamAllCoach
            : DatabaseUser(licenseId: licenseId).streamAllUsers,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserData>?> snapshot) {
          if (snapshot.hasData) {
            List<UserData> coachList = snapshot.data!;
            return CupertinoAlertDialog(
              title: Text(
                widget.isSelectCoach
                    ? AppLocalizations.of(context)!.assignCoach
                    : AppLocalizations.of(context)!.assignTeam,
              ),
              content: SizedBox(
                height: 100,
                child: CupertinoPicker(
                  onSelectedItemChanged: (value) {
                    setState(() => selectedValue = value - 1);
                  },
                  itemExtent: 32.0,
                  magnification: 1,
                  children: [
                    Text(
                      widget.isSelectCoach
                          ? AppLocalizations.of(context)!.selectCoach
                          : AppLocalizations.of(context)!.selectTeam,
                    ),
                    for (var i = 0; i < coachList.length; i++)
                      Text(
                        '${coachList[i].name} ${coachList[i].surname}',
                      )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(
                          color: CupertinoColors.destructiveRed),
                    )),
                TextButton(
                    onPressed: () async {
                      widget.isSelectCoach
                          ? await DatabaseSpeaker(
                                  licenseId: licenseId,
                                  id: widget.speakerData.id)
                              .editSpeakerCoach(
                              uidCoach: coachList[selectedValue].uid,
                            )
                              .then((_) {
                              EasyLoading.showToast(
                                  AppLocalizations.of(context)!.assigned,
                                  duration: const Duration(
                                      milliseconds: kDurationToast),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            })
                          : await DatabaseSpeaker(
                                  licenseId: licenseId,
                                  id: widget.speakerData.id)
                              .editSpeakerUidCreator(
                              uidTeam: coachList[selectedValue].uid,
                            )
                              .then((_) {
                              EasyLoading.showToast(
                                  AppLocalizations.of(context)!.assigned,
                                  duration: const Duration(
                                      milliseconds: kDurationToast),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.assign,
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    )),
              ],
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        });
  }
}
