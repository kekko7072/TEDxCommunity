import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class AddCoachOrTeamMember extends StatefulWidget {
  final bool isSelectCoach;
  final Speaker speakerData;

  AddCoachOrTeamMember({
    required this.isSelectCoach,
    required this.speakerData,
  });

  @override
  _AddCoachOrTeamMemberState createState() => _AddCoachOrTeamMemberState();
}

class _AddCoachOrTeamMemberState extends State<AddCoachOrTeamMember> {
  int selectedValue = 0;
  String licenseId = "";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.isSelectCoach
            ? FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'Role.coach')
                .snapshots()
            : FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            List<UserData> coachList = DatabaseUser(licenseId: licenseId)
                .userListFromSnapshot(snapshot.data!);
            return CupertinoAlertDialog(
              title: Text(
                widget.isSelectCoach ? 'Assegna coach' : 'Assegna membro team',
              ),
              content: Container(
                height: 100,
                child: CupertinoPicker(
                  onSelectedItemChanged: (value) {
                    setState(() {
                      selectedValue = value - 1;
                    });
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
                      'Annulla',
                      style: TextStyle(color: CupertinoColors.destructiveRed),
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
                                  duration:
                                      Duration(milliseconds: kDurationToast),
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
                                  duration:
                                      Duration(milliseconds: kDurationToast),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Assegna',
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    )),
              ],
            );
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        });
  }
}
