import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Confirmed extends StatefulWidget {
  final bool showMobileTitle;

  const Confirmed({super.key, required this.showMobileTitle});

  @override
  State<Confirmed> createState() => _ConfirmedState();
}

class _ConfirmedState extends State<Confirmed> {
  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    final license = Provider.of<License?>(context);

    final userData = Provider.of<UserData?>(context);
    final listSpeaker = Provider.of<List<Speaker>?>(context);

    ///Filter the speaker in CONFIRMED
    List<Speaker> speakersConfirmed = [];

    if (listSpeaker?.length != null) {
      for (var i in listSpeaker!) {
        if (i.progress == Progress.confirmed) {
          speakersConfirmed.add(i);
        }
      }
    }
    return SafeArea(
      top: false,
      child: userData != null && license != null
          ? CustomScrollView(
              semanticChildCount:
                  speakersConfirmed.isNotEmpty ? speakersConfirmed.length : 1,
              slivers: <Widget>[
                if (widget.showMobileTitle) ...[
                  TopBarTeam(
                      license: license,
                      userData: userData,
                      title: AppLocalizations.of(context)!.confirmed),
                ],
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < speakersConfirmed.length) {
                        if (userData.role == Role.master ||
                            userData.role == Role.admin ||
                            userData.role == Role.coach ||
                            userData.uid ==
                                speakersConfirmed[index].uidCreator) {
                          return SafeArea(
                            top: false,
                            bottom: false,
                            minimum: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: Slidable(
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor:
                                        CupertinoColors.destructiveRed,
                                    foregroundColor: Style.whiteColor,
                                    icon: CupertinoIcons.clear_thick,
                                    label: AppLocalizations.of(context)!.remove,
                                    onPressed: (context) async =>
                                        DatabaseSpeaker(
                                                licenseId: licenseId,
                                                id: speakersConfirmed[index].id)
                                            .removeFromThisEvent()
                                            .then((_) {
                                      EasyLoading.showToast(
                                          AppLocalizations.of(context)!.removed,
                                          duration: const Duration(
                                              milliseconds: kDurationToast),
                                          dismissOnTap: true,
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    }),
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  if (userData.role != Role.volunteer) ...[
                                    SlidableAction(
                                      backgroundColor: CupertinoColors.link,
                                      foregroundColor: Style.whiteColor,
                                      icon: CupertinoIcons
                                          .person_crop_circle_badge_plus,
                                      label: AppLocalizations.of(context)!
                                          .assignTeam,
                                      onPressed: (context) async =>
                                          await showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                          return AddCoachOrTeamMember(
                                            isSelectCoach: false,
                                            speakerData:
                                                speakersConfirmed[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                  SlidableAction(
                                    backgroundColor:
                                        CupertinoColors.activeGreen,
                                    foregroundColor: Style.whiteColor,
                                    icon: CupertinoIcons
                                        .person_crop_circle_badge_plus,
                                    label: AppLocalizations.of(context)!
                                        .assignCoach,
                                    onPressed: (context) async =>
                                        await showCupertinoDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return AddCoachOrTeamMember(
                                          isSelectCoach: true,
                                          speakerData: speakersConfirmed[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              child: SpeakerItem(
                                userData: userData,
                                speaker: speakersConfirmed[index],
                                lastItem: index == speakersConfirmed.length - 1,
                                currentProgress: Progress.confirmed,
                              ),
                            ),
                          );
                        } else {
                          return SpeakerItem(
                            userData: userData,
                            speaker: speakersConfirmed[index],
                            lastItem: index == speakersConfirmed.length - 1,
                            currentProgress: Progress.confirmed,
                          );
                        }
                      }
                      return null;
                    },
                  ),
                )
              ],
            )
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
}
