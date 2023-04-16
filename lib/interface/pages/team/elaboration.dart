import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Elaboration extends StatefulWidget {
  final bool showMobileTitle;

  const Elaboration({super.key, required this.showMobileTitle});

  @override
  State<Elaboration> createState() => _ElaborationState();
}

class _ElaborationState extends State<Elaboration> {
  final AuthService auth = AuthService();
  String licenseId = "NO_ID";
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

    ///Filter the speaker in SELECTED
    List<Speaker> speakersSelected = [];

    if (listSpeaker?.length != null) {
      for (var i in listSpeaker!) {
        if (i.progress == Progress.selected) {
          speakersSelected.add(i);
        }
      }
    }

    ///Filter the speaker in CONTACTED
    List<Speaker> speakersContacted = [];

    if (listSpeaker?.length != null) {
      for (var i in listSpeaker!) {
        if (i.progress == Progress.contacted) {
          speakersContacted.add(i);
        }
      }
    }

    ///Filter the speaker in REJECTED
    List<Speaker> speakersRejected = [];

    if (listSpeaker?.length != null) {
      for (var i in listSpeaker!) {
        if (i.progress == Progress.rejected) {
          speakersRejected.add(i);
        }
      }
    }

    return SafeArea(
      top: false,
      child: userData != null && license != null
          ? Stack(children: [
              CustomScrollView(
                slivers: <Widget>[
                  if (widget.showMobileTitle) ...[
                    TopBarTeam(
                        license: license,
                        userData: userData,
                        title: AppLocalizations.of(context)!.elaboration),
                  ],

                  ///SELECTED
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.selected,
                          style: kPageSubtitleStyle.copyWith(
                            color: Style.textColor(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < speakersSelected.length) {
                          if (userData.role == Role.master ||
                              userData.role == Role.admin ||
                              userData.role == Role.coach ||
                              userData.uid ==
                                  speakersSelected[index].uidCreator) {
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
                                      label:
                                          AppLocalizations.of(context)!.remove,
                                      onPressed: (context) async =>
                                          await DatabaseSpeaker(
                                                  licenseId: licenseId,
                                                  id: speakersSelected[index]
                                                      .id)
                                              .updateProgress(
                                                  progress: Progress.backlog)
                                              .then((_) {
                                        EasyLoading.showToast(
                                            AppLocalizations.of(context)!
                                                .removed,
                                            duration: const Duration(
                                                milliseconds: kDurationToast),
                                            dismissOnTap: true,
                                            toastPosition:
                                                EasyLoadingToastPosition
                                                    .bottom);
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
                                                  speakersSelected[index],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    SlidableAction(
                                      backgroundColor:
                                          CupertinoColors.activeGreen,
                                      foregroundColor: Style.whiteColor,
                                      icon: CupertinoIcons.check_mark,
                                      label:
                                          AppLocalizations.of(context)!.contact,
                                      onPressed: (context) async =>
                                          await showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                          return SelectTypeOfContact(
                                              firstContact: true,
                                              userData: userData,
                                              speaker: speakersSelected[index]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                child: SpeakerItem(
                                  userData: userData,
                                  speaker: speakersSelected[index],
                                  lastItem:
                                      index == speakersSelected.length - 1,
                                  currentProgress: Progress.selected,
                                ),
                              ),
                            );
                          } else {
                            return SpeakerItem(
                              userData: userData,
                              speaker: speakersSelected[index],
                              lastItem: index == speakersSelected.length - 1,
                              currentProgress: Progress.selected,
                            );
                          }
                        }
                        return null;
                      },
                    ),
                  ),

                  ///CONTACTED
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.contacted,
                          style: kPageSubtitleStyle.copyWith(
                            color: Style.textColor(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < speakersContacted.length) {
                          if (userData.role == Role.master ||
                              userData.role == Role.admin ||
                              userData.role == Role.coach ||
                              userData.uid ==
                                  speakersContacted[index].uidCreator) {
                            String speakerID = AuthService().getRandomString(5);
                            String speakerPSSWD =
                                AuthService().getRandomString(8);
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
                                      label: AppLocalizations.of(context)!
                                          .rejected,
                                      onPressed: (context) async =>
                                          await DatabaseSpeaker(
                                                  licenseId: licenseId,
                                                  id: speakersContacted[index]
                                                      .id)
                                              .updateProgress(
                                                  progress: Progress.rejected)
                                              .then((_) {
                                        EasyLoading.showToast(
                                            AppLocalizations.of(context)!
                                                .rejected,
                                            duration: const Duration(
                                                milliseconds: kDurationToast),
                                            dismissOnTap: true,
                                            toastPosition:
                                                EasyLoadingToastPosition
                                                    .bottom);
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
                                                  speakersContacted[index],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    SlidableAction(
                                        backgroundColor:
                                            CupertinoColors.activeGreen,
                                        foregroundColor: Style.whiteColor,
                                        icon: CupertinoIcons.check_mark,
                                        label: AppLocalizations.of(context)!
                                            .confirmed,
                                        onPressed: (context) async => await auth
                                                .registerSpeakerWithEmailAndPassword(
                                                    licenseId: licenseId,
                                                    uidCreator:
                                                        speakersContacted[index]
                                                            .uidCreator,
                                                    accessID: speakerID,
                                                    accessPassword:
                                                        speakerPSSWD,
                                                    progress:
                                                        Progress.confirmed,
                                                    name:
                                                        speakersContacted[index]
                                                            .name,
                                                    email:
                                                        speakersContacted[index]
                                                            .email,
                                                    link:
                                                        speakersContacted[index]
                                                            .link,
                                                    description:
                                                        speakersContacted[index]
                                                            .description,
                                                    context: context)
                                                .then((result) async {
                                              if (result != null) {
                                                showCupertinoDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return CupertinoAlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: Column(
                                                        children: [
                                                          const Text(
                                                              'Error in creation of speaker profile'),
                                                          Text(auth.error),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .cancel,
                                                              style: const TextStyle(
                                                                  color: CupertinoColors
                                                                      .destructiveRed),
                                                            )),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                ///1. Elimina vecchio DOC speaker
                                                await DatabaseSpeaker(
                                                        licenseId: licenseId,
                                                        id: speakersContacted[
                                                                index]
                                                            .id)
                                                    .deleteSpeaker()
                                                    .then((_) {
                                                  ///2. Mostra conferma
                                                  EasyLoading.showToast(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .confirmed,
                                                      duration: const Duration(
                                                          milliseconds:
                                                              kDurationToast),
                                                      dismissOnTap: true,
                                                      toastPosition:
                                                          EasyLoadingToastPosition
                                                              .bottom);
                                                });
                                              }
                                            }))
                                  ],
                                ),
                                child: SpeakerItem(
                                  userData: userData,
                                  speaker: speakersContacted[index],
                                  lastItem:
                                      index == speakersContacted.length - 1,
                                  currentProgress: Progress.contacted,
                                ),
                              ),
                            );
                          } else {
                            return SpeakerItem(
                              userData: userData,
                              speaker: speakersContacted[index],
                              lastItem: index == speakersContacted.length - 1,
                              currentProgress: Progress.selected,
                            );
                          }
                        }
                        return null;
                      },
                    ),
                  ),

                  ///REJECTED
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.rejected,
                          style: kPageSubtitleStyle.copyWith(
                            color: Style.textColor(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < speakersRejected.length) {
                          if (userData.role == Role.master ||
                              userData.role == Role.admin ||
                              userData.role == Role.coach ||
                              userData.uid ==
                                  speakersRejected[index].uidCreator) {
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
                                      label:
                                          AppLocalizations.of(context)!.remove,
                                      onPressed: (context) async =>
                                          await DatabaseSpeaker(
                                                  licenseId: licenseId,
                                                  id: speakersRejected[index]
                                                      .id)
                                              .removeFromThisEvent()
                                              .then((_) {
                                        EasyLoading.showToast(
                                            AppLocalizations.of(context)!
                                                .removed,
                                            duration: const Duration(
                                                milliseconds: kDurationToast),
                                            dismissOnTap: true,
                                            toastPosition:
                                                EasyLoadingToastPosition
                                                    .bottom);
                                      }),
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor:
                                          CupertinoColors.activeGreen,
                                      foregroundColor: Style.whiteColor,
                                      icon: CupertinoIcons.arrow_up,
                                      label:
                                          AppLocalizations.of(context)!.recover,
                                      onPressed: (context) async =>
                                          await DatabaseSpeaker(
                                                  licenseId: licenseId,
                                                  id: speakersRejected[index]
                                                      .id)
                                              .updateProgress(
                                                  progress: Progress.contacted)
                                              .then((_) {
                                        EasyLoading.showToast(
                                            AppLocalizations.of(context)!
                                                .recovered,
                                            duration: const Duration(
                                                milliseconds: kDurationToast),
                                            dismissOnTap: true,
                                            toastPosition:
                                                EasyLoadingToastPosition
                                                    .bottom);
                                      }),
                                    ),
                                  ],
                                ),
                                child: SpeakerItem(
                                  userData: userData,
                                  speaker: speakersRejected[index],
                                  lastItem:
                                      index == speakersRejected.length - 1,
                                  currentProgress: Progress.selected,
                                ),
                              ),
                            );
                          } else {
                            return SpeakerItem(
                              userData: userData,
                              speaker: speakersRejected[index],
                              lastItem: index == speakersRejected.length - 1,
                              currentProgress: Progress.contacted,
                            );
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ])
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
}
