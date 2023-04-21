import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tedxcommunity/services/imports.dart';

class SpeakerItem extends StatefulWidget {
  const SpeakerItem({
    super.key,
    required this.userData,
    required this.speaker,
    required this.lastItem,
    required this.currentProgress,
  });

  final UserData userData;
  final Speaker speaker;
  final bool lastItem;
  final Progress currentProgress;

  @override
  State<SpeakerItem> createState() => _SpeakerItemState();
}

class _SpeakerItemState extends State<SpeakerItem> {
  String profession = '';

  String topic = '';

  String ratePublicSpeaking = '';

  String justTEDx = '';

  String bio = '';

  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    ///Profession
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker0) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker1)) {
      int startIndexProfession =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker0);
      int endIndexProfession = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker1,
          startIndexProfession + TextLabels.kAddSpeaker0.length);
      profession = widget.speaker.description.substring(
          startIndexProfession + TextLabels.kAddSpeaker0.length,
          endIndexProfession);
    } else {
      profession = '\n';
    }

    ///TOPIC
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker1) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker2)) {
      int startIndexTopic =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker1);
      int endIndexTopic = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker2,
          startIndexTopic + TextLabels.kAddSpeaker1.length);
      topic = widget.speaker.description.substring(
          startIndexTopic + TextLabels.kAddSpeaker1.length, endIndexTopic);
    } else {
      topic = '\n';
    }

    ///Rate
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker2) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker3)) {
      int startIndexRate =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker2);
      int endIndexRate = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker3,
          startIndexRate + TextLabels.kAddSpeaker2.length);
      ratePublicSpeaking = widget.speaker.description.substring(
          startIndexRate + TextLabels.kAddSpeaker2.length, endIndexRate);
    } else {
      ratePublicSpeaking = '\n';
    }

    ///JustTEDx
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker3) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker4)) {
      int startIndexJustTEDx =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker3);
      int endIndexJustTEDx = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker4,
          startIndexJustTEDx + TextLabels.kAddSpeaker3.length);
      justTEDx = widget.speaker.description.substring(
          startIndexJustTEDx + TextLabels.kAddSpeaker3.length,
          endIndexJustTEDx);
    } else {
      justTEDx = '\n';
    }

    ///Bio
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker4)) {
      int startIndexBio =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker4);

      bio = widget.speaker.description.substring(
          startIndexBio + TextLabels.kAddSpeaker4.length,
          widget.speaker.description.length);
    } else {
      bio = '\n';
    }
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.grey,
            ),
            onPressed: () {
              final controller = Slidable.of(context)!;
              final isClosed = controller.actionPaneType.value ==
                  ActionPaneType
                      .none; // you can use this to check if its closed
              if (isClosed) {
                // use this to open it
                controller.openStartActionPane();
              } else {
                // if you want to close the ActionPane
                controller.close();
              }
            },
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.speaker.name,
                            style: kSpeakerTitleStyle.copyWith(
                                color: CupertinoDynamicColor.resolve(
                                    CupertinoDynamicColor.withBrightness(
                                      color:
                                          widget.userData.role == Role.coach &&
                                                  widget.userData.uid !=
                                                      widget.speaker.coach
                                              ? kColorDivider
                                              : kColorBlack,
                                      darkColor:
                                          widget.userData.role == Role.coach &&
                                                  widget.userData.uid !=
                                                      widget.speaker.coach
                                              ? kColorGrey
                                              : kColorWhite,
                                    ),
                                    context))),
                        const Padding(padding: EdgeInsets.only(top: 8)),
                        StreamBuilder<UserData>(
                            stream: DatabaseUser(
                                    licenseId: licenseId,
                                    uid: widget.speaker.uidCreator.isNotEmpty
                                        ? widget.speaker.uidCreator
                                        : 'unk')
                                .userData,
                            builder: (BuildContext context,
                                AsyncSnapshot<UserData> snapshot) {
                              if (snapshot.hasData) {
                                UserData userData = snapshot.data!;
                                return RichText(
                                  text: TextSpan(
                                    style: kSpeakerDescriptionStyle.copyWith(
                                        color: const Color(0xFF8E8E93)),
                                    children: <TextSpan>[
                                      if (widget.currentProgress ==
                                          Progress.backlog) ...[
                                        TextSpan(
                                            text:
                                                '${AppLocalizations.of(context)!.reportedBy}: ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ] else if (widget.currentProgress ==
                                              Progress.selected ||
                                          widget.currentProgress ==
                                              Progress.confirmed) ...[
                                        TextSpan(
                                            text:
                                                '${AppLocalizations.of(context)!.assignedTo}: ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ] else if (widget.currentProgress ==
                                          Progress.contacted) ...[
                                        TextSpan(
                                            text:
                                                '${AppLocalizations.of(context)!.contactedBy}: ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                      TextSpan(
                                        text:
                                            '${userData.name} ${userData.surname}',
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                        const SizedBox(height: 2),
                        if (widget.currentProgress == Progress.confirmed) ...[
                          RichText(
                            text: TextSpan(
                              style: kSpeakerDescriptionStyle.copyWith(
                                  color: const Color(0xFF8E8E93)),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${AppLocalizations.of(context)!.coaching}: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: StepService.loadStepCoachingTitle(
                                      widget.speaker.coachingStep),
                                ),
                                TextSpan(
                                    text:
                                        '\n${AppLocalizations.of(context)!.management}: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: StepService.loadStepManagementText(
                                      widget.speaker.managementStep),
                                ),
                              ],
                            ),
                          )
                        ] else if (widget.currentProgress ==
                            Progress.contacted) ...[
                          RichText(
                            text: TextSpan(
                              style: kSpeakerDescriptionStyle.copyWith(
                                  color: const Color(0xFF8E8E93)),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${AppLocalizations.of(context)!.contacted}: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.speaker.managementStepDate
                                      .substring(0, 10),
                                ),
                              ],
                            ),
                          )
                        ] else ...[
                          RichText(
                            text: TextSpan(
                              style: kSpeakerDescriptionStyle.copyWith(
                                  color: const Color(0xFF8E8E93)),
                              children: <TextSpan>[
                                TextSpan(
                                    text: TextLabels.kAddSpeaker0,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: profession),
                                TextSpan(
                                    text: TextLabels.kAddSpeaker1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: topic),
                                if (widget.currentProgress !=
                                    Progress.selected) ...[
                                  TextSpan(
                                      text: TextLabels.kAddSpeaker2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: ratePublicSpeaking),
                                  TextSpan(
                                      text: TextLabels.kAddSpeaker3,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: justTEDx),
                                  TextSpan(
                                      text: TextLabels.kAddSpeaker4,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: bio),
                                ]
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => EditSpeaker(
                            speaker: widget.speaker,
                            canDelete: widget.userData.role == Role.master ||
                                    widget.userData.role == Role.admin ||
                                    widget.userData.role == Role.coach ||
                                    widget.userData.uid ==
                                        widget.speaker.uidCreator
                                ? true
                                : false,
                            progress: widget.currentProgress),
                      );
                    },
                    child: Icon(
                      CupertinoIcons.ellipsis_vertical,
                      semanticLabel: AppLocalizations.of(context)!.edit,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              onTap: () {
                if (widget.currentProgress == Progress.confirmed) {
                  showCupertinoModalBottomSheet(
                    backgroundColor: Style.backgroundColor(context),
                    context: context,
                    isDismissible: true,
                    builder: (context) => ConfirmedTeam(
                        userData: widget.userData, speaker: widget.speaker),
                  );
                } else {
                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return SpeakerProfile(widget.speaker);
                    },
                  );
                }
              },
              onLongPress: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => EditSpeaker(
                      speaker: widget.speaker,
                      canDelete: widget.userData.role == Role.master ||
                              widget.userData.role == Role.admin ||
                              widget.userData.role == Role.coach ||
                              widget.userData.uid == widget.speaker.uidCreator
                          ? true
                          : false,
                      progress: widget.currentProgress),
                );
              },
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.forward,
              color: Colors.grey,
            ),
            onPressed: () {
              final controller = Slidable.of(context)!;
              final isClosed = controller.actionPaneType.value ==
                  ActionPaneType
                      .none; // you can use this to check if its closed
              if (isClosed) {
                // use this to open it
                controller.openEndActionPane();
              } else {
                // if you want to close the ActionPane
                controller.close();
              }
            },
          ),
        ],
      ),
    );

    if (widget.lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: kColorDivider,
          ),
        ),
      ],
    );
  }
}
