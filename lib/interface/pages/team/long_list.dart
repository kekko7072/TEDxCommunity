import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LongList extends StatefulWidget {
  final bool showMobileTitle;
  final AudioHandler audioHandler;

  const LongList(
      {super.key, required this.showMobileTitle, required this.audioHandler});

  @override
  LongListState createState() => LongListState();
}

class LongListState extends State<LongList> {
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

    ///Filter the speaker in BACKLOG
    List<Speaker> speakersBacklog = [];
    if (listSpeaker?.length != null) {
      for (var i in listSpeaker!) {
        if (i.progress == Progress.backlog) {
          speakersBacklog.add(i);
        }
      }
    }

    return SafeArea(
        top: false,
        child: userData != null && license != null
            ? CustomScrollView(
                semanticChildCount:
                    speakersBacklog.isNotEmpty ? speakersBacklog.length : 1,
                slivers: <Widget>[
                  if (widget.showMobileTitle) ...[
                    TopBarTeam(
                        userData: userData,
                        license: license,
                        title: AppLocalizations.of(context)!.list,
                        widget: GestureDetector(
                          child: const Icon(CupertinoIcons.waveform_circle),
                          onTap: () => showCupertinoModalBottomSheet(
                              context: context,
                              builder: (_) => VocalAssistantSpeaker(
                                    userData: userData,
                                    speakers: speakersBacklog,
                                    audioHandler: widget.audioHandler,
                                  )),
                        )),
                  ],
                  speakersBacklog.isEmpty
                      ? SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton.filled(
                                  child: Text(
                                      AppLocalizations.of(context)!.speakerAdd),
                                  onPressed: () => showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AddSpeaker(uid: userData.uid);
                                        },
                                      )),
                            ],
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < speakersBacklog.length) {
                                if (userData.role == Role.master ||
                                    userData.role == Role.admin ||
                                    userData.role == Role.coach) {
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
                                                .remove,
                                            onPressed: (context) async =>
                                                await DatabaseSpeaker(
                                                        licenseId: licenseId,
                                                        id: speakersBacklog[
                                                                index]
                                                            .id)
                                                    .removeFromThisEvent()
                                                    .then((_) {
                                              EasyLoading.showToast(
                                                  AppLocalizations.of(context)!
                                                      .removed,
                                                  duration: const Duration(
                                                      milliseconds:
                                                          kDurationToast),
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
                                                CupertinoColors.link,
                                            foregroundColor: Style.whiteColor,
                                            icon: CupertinoIcons
                                                .person_crop_circle_badge_plus,
                                            label: AppLocalizations.of(context)!
                                                .assignTeam,
                                            onPressed: (context) =>
                                                showCupertinoDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (context) {
                                                return AddCoachOrTeamMember(
                                                  isSelectCoach: false,
                                                  speakerData:
                                                      speakersBacklog[index],
                                                );
                                              },
                                            ),
                                          ),
                                          SlidableAction(
                                            backgroundColor:
                                                CupertinoColors.activeGreen,
                                            foregroundColor: Style.whiteColor,
                                            icon: CupertinoIcons.check_mark,
                                            label: AppLocalizations.of(context)!
                                                .approve,
                                            onPressed: (context) async =>
                                                await DatabaseSpeaker(
                                                        licenseId: licenseId,
                                                        id: speakersBacklog[
                                                                index]
                                                            .id)
                                                    .updateProgress(
                                                        progress:
                                                            Progress.selected)
                                                    .then((_) {
                                              EasyLoading.showToast(
                                                  AppLocalizations.of(context)!
                                                      .approved,
                                                  duration: const Duration(
                                                      milliseconds:
                                                          kDurationToast),
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
                                        speaker: speakersBacklog[index],
                                        lastItem:
                                            index == speakersBacklog.length - 1,
                                        currentProgress: Progress.backlog,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SpeakerItem(
                                    userData: userData,
                                    speaker: speakersBacklog[index],
                                    lastItem:
                                        index == speakersBacklog.length - 1,
                                    currentProgress: Progress.backlog,
                                  );
                                }
                              }
                              return null;
                            },
                          ),
                        )
                ],
              )
            : const Center(child: CupertinoActivityIndicator()));
  }
}
