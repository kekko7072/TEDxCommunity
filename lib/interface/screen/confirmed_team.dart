import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tedxcommunity/services/imports.dart';

class ConfirmedTeam extends StatefulWidget {
  const ConfirmedTeam({
    super.key,
    required this.userData,
    required this.speaker,
  });

  final UserData userData;
  final Speaker speaker;

  @override
  ConfirmedTeamState createState() => ConfirmedTeamState();
}

class ConfirmedTeamState extends State<ConfirmedTeam> {
  int currentManagementStep = 0;
  int currentCoachingStep = 0;

  bool selectedIndexValue = true;
  bool selectedIndexValueManagement = true;

  bool dateSelected = false;
  String coachingStepDate = '';
  DateTime coachingDate = DateTime.now().toUtc().toLocal();

  String licenseId = "";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));

    setState(() {
      currentManagementStep = widget.speaker.managementStep - 1;
      currentCoachingStep = widget.speaker.coachingStep - 1;
      coachingStepDate = widget.speaker.coachingStepDate.isNotEmpty
          ? DateFormat('kk:mm  dd-MM-yyyy')
              .format(DateTime.parse(widget.speaker.coachingStepDate))
          : '';

      if (widget.speaker.coachingStepDate.isNotEmpty) {
        dateSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: const Icon(CupertinoIcons.profile_circled),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return SpeakerProfile(widget.speaker);
                          },
                        );
                      }),
                ),
                widget.userData.role == Role.coach
                    ? Text(
                        AppLocalizations.of(context)!.coaching,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle,
                      )
                    : Align(
                        alignment: Alignment.topCenter,
                        child: CupertinoSegmentedControl(
                          borderColor: Style.primaryColor,
                          selectedColor: Style.primaryColor,
                          unselectedColor: Style.backgroundColor(context),
                          children: {
                            true: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.coaching,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            false: Text(
                              AppLocalizations.of(context)!.management,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          },
                          groupValue: selectedIndexValue,
                          onValueChanged: (bool value) {
                            setState(
                              () {
                                selectedIndexValue = value;
                              },
                            );
                          },
                        ),
                      ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: const Icon(CupertinoIcons.clear_circled_solid),
                      onPressed: () => Navigator.of(context).pop()),
                ),
              ],
            ),
            selectedIndexValue
                ? currentCoachingStep < 4
                    ? buildCoachingStepper(StepperType.vertical)
                    : EndCoachingOrManagement(
                        isCoaching: true,
                        onPressedEdit: () async {
                          if (widget.userData.role != Role.volunteer ||
                              widget.userData.uid ==
                                  widget.speaker.uidCreator) {
                            setState(() {
                              currentCoachingStep = 3;
                            });
                            await DatabaseSpeaker(
                                    licenseId: licenseId, id: widget.speaker.id)
                                .updateCoachingStep(step: 4);
                          }
                        },
                      )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoSegmentedControl(
                        borderColor: Style.primaryColor,
                        selectedColor: Style.primaryColor,
                        unselectedColor: Style.backgroundColor(context),
                        children: {
                          true: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                AppLocalizations.of(context)!.requests,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                          false: Text(
                            AppLocalizations.of(context)!.data,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        },
                        groupValue: selectedIndexValueManagement,
                        onValueChanged: (bool value) {
                          setState(
                            () {
                              selectedIndexValueManagement = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      selectedIndexValueManagement
                          ? currentManagementStep < 2
                              ? buildManagementStepper(StepperType.vertical)
                              : EndCoachingOrManagement(
                                  isCoaching: false,
                                  onPressedEdit: () async {
                                    if (widget.userData.role !=
                                            Role.volunteer ||
                                        widget.userData.uid ==
                                            widget.speaker.uidCreator) {
                                      setState(() {
                                        currentManagementStep = 1;
                                      });
                                      await DatabaseSpeaker(
                                              licenseId: licenseId,
                                              id: widget.speaker.id)
                                          .updateManagementStep(step: 1);
                                    }
                                  },
                                )
                          : ManagementData(speaker: widget.speaker),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  CupertinoStepper buildCoachingStepper(StepperType type) {
    bool canCancel = currentCoachingStep > 0;
    bool canContinue = currentCoachingStep < 4;
    return CupertinoStepper(
      type: type,
      currentStep: currentCoachingStep,
      onStepTapped: (step) => setState(() => currentCoachingStep = step),
      onStepCancel: canCancel
          ? () => setState(() {
                if (widget.userData.role != Role.volunteer ||
                    widget.userData.uid == widget.speaker.uidCreator) {
                  --currentCoachingStep;
                  DatabaseSpeaker(licenseId: licenseId, id: widget.speaker.id)
                      .updateCoachingStep(step: currentCoachingStep + 1);
                }
              })
          : null,
      onStepContinue: canContinue
          ? () => setState(() {
                if (widget.userData.role != Role.volunteer ||
                    widget.userData.uid == widget.speaker.uidCreator) {
                  dateSelected = false;
                  coachingStepDate = '';
                  ++currentCoachingStep;
                  DatabaseSpeaker(licenseId: licenseId, id: widget.speaker.id)
                      .updateCoachingStep(step: currentCoachingStep + 1);
                }
              })
          : null,
      steps: [
        buildCoachingStep(
            context: context,
            licenseId: licenseId,
            speakerID: widget.speaker.id,
            title: StepService(context).loadStepCoachingTitle(1),
            subtitle: currentCoachingStep > 0
                ? AppLocalizations.of(context)!.completed
                : currentCoachingStep == 0
                    ? AppLocalizations.of(context)!.inProgress
                    : AppLocalizations.of(context)!.toDo,
            state: currentCoachingStep >= 0
                ? StepState.complete
                : StepState.disabled,
            showButton: true,
            dateIsSelected: dateSelected,
            linkVideoCall: widget.speaker.link,
            buttonText: dateSelected
                ? AppLocalizations.of(context)!.edit
                : AppLocalizations.of(context)!.select,
            buttonAction: () => {},
            content: dateSelected
                ? '${AppLocalizations.of(context)!.meetWillTakePlaceAt}  $coachingStepDate .'
                : AppLocalizations.of(context)!.setDateForMeeting),
        buildCoachingStep(
            context: context,
            licenseId: licenseId,
            speakerID: widget.speaker.id,
            title: StepService(context).loadStepCoachingTitle(2),
            subtitle: currentCoachingStep > 1
                ? AppLocalizations.of(context)!.completed
                : currentCoachingStep == 1
                    ? AppLocalizations.of(context)!.inProgress
                    : AppLocalizations.of(context)!.toDo,
            state: currentCoachingStep >= 1
                ? StepState.complete
                : StepState.disabled,
            dateIsSelected: false,
            showButton: widget.speaker.talkDownloadLink! == '' ? false : true,
            buttonText: AppLocalizations.of(context)!.download,
            buttonAction: () async {
              if (widget.userData.role != Role.volunteer) {
                if (await canLaunchUrlString(
                    widget.speaker.talkDownloadLink!)) {
                  await launchUrlString(
                    widget.speaker.talkDownloadLink!,
                  );
                } else {
                  throw 'Could not launch the url';
                }
              }
            },
            content: widget.speaker.talkDownloadLink! == ''
                ? AppLocalizations.of(context)!.prepareSpeech
                : AppLocalizations.of(context)!.downloadSpeech),
        buildCoachingStep(
            licenseId: licenseId,
            context: context,
            speakerID: widget.speaker.id,
            title: StepService(context).loadStepCoachingTitle(3),
            subtitle: currentCoachingStep > 2
                ? AppLocalizations.of(context)!.completed
                : currentCoachingStep == 2
                    ? AppLocalizations.of(context)!.inProgress
                    : AppLocalizations.of(context)!.toDo,
            state: currentCoachingStep >= 2
                ? StepState.complete
                : StepState.disabled,
            showButton: true,
            dateIsSelected: dateSelected,
            linkVideoCall: widget.speaker.link,
            buttonText: dateSelected
                ? AppLocalizations.of(context)!.edit
                : AppLocalizations.of(context)!.select,
            buttonAction: () => {},
            content: dateSelected
                ? '${AppLocalizations.of(context)!.meetWillTakePlaceAt}  $coachingStepDate .'
                : AppLocalizations.of(context)!.setDateForMeeting),
        buildCoachingStep(
          licenseId: licenseId,
          context: context,
          speakerID: widget.speaker.id,
          title: StepService(context).loadStepCoachingTitle(4),
          subtitle: currentCoachingStep > 3
              ? AppLocalizations.of(context)!.completed
              : currentCoachingStep == 3
                  ? AppLocalizations.of(context)!.inProgress
                  : AppLocalizations.of(context)!.toDo,
          state: currentCoachingStep >= 3
              ? StepState.complete
              : StepState.disabled,
          showButton: true,
          dateIsSelected: dateSelected,
          linkVideoCall: widget.speaker.link,
          buttonText: dateSelected
              ? AppLocalizations.of(context)!.edit
              : AppLocalizations.of(context)!.select,
          buttonAction: () => {},
          content: dateSelected
              ? '${AppLocalizations.of(context)!.meetWillTakePlaceAt}  $coachingStepDate .'
              : AppLocalizations.of(context)!.setDateForMeeting,
        ),
      ],
    );
  }

  CupertinoStepper buildManagementStepper(StepperType type) {
    bool canCancel = currentManagementStep > 0;
    bool canContinue = currentManagementStep < 4;
    return CupertinoStepper(
      type: type,
      currentStep: currentManagementStep,
      onStepTapped: (step) => setState(() => currentManagementStep = step),
      onStepCancel: canCancel
          ? () => setState(() {
                if (widget.userData.role != Role.volunteer ||
                    widget.userData.uid == widget.speaker.uidCreator) {
                  --currentManagementStep;
                  DatabaseSpeaker(licenseId: licenseId, id: widget.speaker.id)
                      .updateManagementStep(step: currentManagementStep + 1);
                }
              })
          : null,
      onStepContinue: canContinue
          ? () => setState(() {
                if (widget.userData.role != Role.volunteer ||
                    widget.userData.uid == widget.speaker.uidCreator) {
                  ++currentManagementStep;
                  DatabaseSpeaker(licenseId: licenseId, id: widget.speaker.id)
                      .updateManagementStep(step: currentManagementStep + 1);
                }
              })
          : null,
      steps: [
        buildManagementStep(
            title: StepService(context).loadStepManagementText(1),
            subtitle: currentManagementStep > 0
                ? AppLocalizations.of(context)!.completed
                : currentManagementStep == 0
                    ? AppLocalizations.of(context)!.inProgress
                    : AppLocalizations.of(context)!.toDo,
            state: currentManagementStep >= 0
                ? StepState.complete
                : StepState.disabled,
            content:
                '${AppLocalizations.of(context)!.moduleOpenedTheDay} ${widget.speaker.managementStepDate.substring(0, 10)} .'),
        buildManagementStep(
            title: StepService(context).loadStepManagementText(2),
            subtitle: currentManagementStep > 1
                ? AppLocalizations.of(context)!.completed
                : currentManagementStep == 1
                    ? AppLocalizations.of(context)!.inProgress
                    : AppLocalizations.of(context)!.toDo,
            state: currentManagementStep >= 1
                ? StepState.complete
                : StepState.disabled,
            content:
                '${AppLocalizations.of(context)!.moduleSendTheDay} ${widget.speaker.managementStepDate.substring(0, 10)} .'),
      ],
    );
  }
}
