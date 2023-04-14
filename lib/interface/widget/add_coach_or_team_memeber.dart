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
  String licenseId = "NO_ID";
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
                widget.isSelectCoach ? 'Assegna coach' : 'Assegna membro team',
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
                          ? 'Seleziona coach'
                          : 'Seleziona membro team',
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
                    onPressed: () {
                      widget.isSelectCoach
                          ? DatabaseSpeaker(
                                  licenseId: licenseId,
                                  id: widget.speakerData.id)
                              .editSpeakerCoach(
                              uidCoach: coachList[selectedValue].uid,
                            )
                              .then((_) {
                              EasyLoading.showToast('Coach assegnato',
                                  duration: const Duration(
                                      milliseconds: kDurationToast),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            })
                          : DatabaseSpeaker(
                                  licenseId: licenseId,
                                  id: widget.speakerData.id)
                              .editSpeakerUidCreator(
                              uidTeam: coachList[selectedValue].uid,
                            )
                              .then((_) {
                              EasyLoading.showToast(
                                  'Speaker affidato a ${coachList[selectedValue].name} ${coachList[selectedValue].surname}',
                                  duration: const Duration(
                                      milliseconds: kDurationToast),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            });
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Assegna',
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    )),
              ],
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        });
  }
}
