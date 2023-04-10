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

  bool showGoogleSignIn = true;

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
        showGoogleSignIn = false;
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
                        'Coaching',
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
                          children: const {
                            true: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Coaching',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            false: Text(
                              'Gestione',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                        children: const {
                          true: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Richieste',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          false: Text(
                            'Dati',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
            title: StepService.loadStepCoachingTitle(1),
            subtitle: currentCoachingStep > 0
                ? 'Completato'
                : currentCoachingStep == 0
                    ? 'In corso'
                    : 'Da fare',
            state: currentCoachingStep >= 0
                ? StepState.complete
                : StepState.disabled,
            showGoogleSignInButton: showGoogleSignIn,
            showButton: true,
            dateIsSelected: dateSelected,
            linkVideoCall: widget.speaker.link,
            buttonText: dateSelected ? 'Modifica' : 'Seleziona',
            buttonAction: () => selectCoachingDate(numberDescription: 1),
            content: dateSelected
                ? 'Il primo incontro si svolgerà alle  $coachingStepDate .'
                : 'Imposta la data per il primo incontro.'),
        buildCoachingStep(
            context: context,
            licenseId: licenseId,
            speakerID: widget.speaker.id,
            title: StepService.loadStepCoachingTitle(2),
            subtitle: currentCoachingStep > 1
                ? 'Completato'
                : currentCoachingStep == 1
                    ? 'In corso'
                    : 'Da fare',
            state: currentCoachingStep >= 1
                ? StepState.complete
                : StepState.disabled,
            showGoogleSignInButton: false,
            dateIsSelected: false,
            showButton: widget.speaker.talkDownloadLink! == '' ? false : true,
            buttonText: 'Scarica',
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
                ? 'Allo speaker è stato affidato di preparare il discorso.'
                : 'Puoi scaricare il discorso dello speaker.'),
        buildCoachingStep(
            licenseId: licenseId,
            context: context,
            speakerID: widget.speaker.id,
            title: StepService.loadStepCoachingTitle(3),
            subtitle: currentCoachingStep > 2
                ? 'Completato'
                : currentCoachingStep == 2
                    ? 'In corso'
                    : 'Da fare',
            state: currentCoachingStep >= 2
                ? StepState.complete
                : StepState.disabled,
            showGoogleSignInButton: showGoogleSignIn,
            showButton: true,
            dateIsSelected: dateSelected,
            linkVideoCall: widget.speaker.link,
            buttonText: dateSelected ? 'Modifica' : 'Seleziona',
            buttonAction: () => selectCoachingDate(numberDescription: 2),
            content: dateSelected
                ? 'L\'incontro si svolgerà alle  $coachingStepDate .'
                : 'Imposta la data dell\'incontro.'),
        buildCoachingStep(
          licenseId: licenseId,
          context: context,
          speakerID: widget.speaker.id,
          title: StepService.loadStepCoachingTitle(4),
          subtitle: currentCoachingStep > 3
              ? 'Completato'
              : currentCoachingStep == 3
                  ? 'In corso'
                  : 'Da fare',
          state: currentCoachingStep >= 3
              ? StepState.complete
              : StepState.disabled,
          showGoogleSignInButton: showGoogleSignIn,
          showButton: true,
          dateIsSelected: dateSelected,
          linkVideoCall: widget.speaker.link,
          buttonText: dateSelected ? 'Modifica' : 'Seleziona',
          buttonAction: () => selectCoachingDate(numberDescription: 3),
          content: dateSelected
              ? 'L\'incontro di revisione si svolgerà alle  $coachingStepDate .'
              : 'Imposta la data per l\'incontro di revisione.',
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
            title: StepService.loadStepManagementText(1),
            subtitle: currentManagementStep > 0
                ? 'Completato'
                : currentManagementStep == 0
                    ? 'In corso'
                    : 'Da fare',
            state: currentManagementStep >= 0
                ? StepState.complete
                : StepState.disabled,
            content:
                'Allo speaker è stato aperto il modulo con le informazioni principali il giorno ${widget.speaker.managementStepDate.substring(0, 10)} .'),
        buildManagementStep(
            title: StepService.loadStepManagementText(2),
            subtitle: currentManagementStep > 1
                ? 'Completato'
                : currentManagementStep == 1
                    ? 'In corso'
                    : 'Da fare',
            state: currentManagementStep >= 1
                ? StepState.complete
                : StepState.disabled,
            content:
                'Il modulo con le le informazioni sulla logistica è stato inviato il giorno ${widget.speaker.managementStepDate.substring(0, 10)} .'),
      ],
    );
  }

  Future<void> selectCoachingDate({required int numberDescription}) async {
    if (widget.userData.role != Role.volunteer &&
            widget.speaker.email.isNotEmpty ||
        widget.userData.uid == widget.speaker.uidCreator &&
            widget.speaker.email.isNotEmpty) {
      /* List<String> ccEmailList = [];
      if (await CalendarService().loadCalendarApi()) {
        setState(() {
          showGoogleSignIn = false;
        });
        bool selectedName = false;
        showCupertinoModalBottomSheet(
          context: context,
          isDismissible: true,
          builder: (_) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                selectedName
                    ? DateTimePickerModal(
                        pickerType: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (val) {
                          setState(() {
                            coachingDate = val;
                          });
                        },
                        onPressed: () async {
                          List<cal.EventAttendee> listAttendee = [
                            cal.EventAttendee(
                              displayName: widget.speaker.name,
                              email: widget.speaker.email,
                            ),
                          ];

                          for (var i = 0; i < ccEmailList.length; i++) {
                            listAttendee
                                .add(cal.EventAttendee(email: ccEmailList[i]));
                          }

                          await CalendarService().insert(
                            userData: widget.userData,
                            edit: dateSelected,
                            speaker: widget.speaker,
                            title:
                                'TEDxCortina - coaching con ${widget.speaker.name}',
                            description:
                                StepService.loadStepCoachingDescription(
                                    numberDescription),
                            attendeeEmailList: listAttendee,
                            startTime: coachingDate,
                          );

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      )
                    : SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Text('Seleziona team da invitare',
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navTitleTextStyle),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                height: 150,
                                child: StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('email',
                                            isNotEqualTo: widget.userData.email)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        List<UserData> staffList =
                                            DatabaseUser().userListFromSnapshot(
                                                snapshot.data!);
                                        if (widget.speaker.uidCreator !=
                                                widget.userData.uid &&
                                            widget.speaker.uidCreator
                                                .isNotEmpty) {
                                          ccEmailList.add(staffList
                                              .where((UserData element) =>
                                                  widget.speaker.uidCreator ==
                                                  element.uid)
                                              .first
                                              .email);
                                        }
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                                  StateSetter setState) =>
                                              ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: staffList.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                    '${staffList[index].name} ${staffList[index].surname}',
                                                    style: TextStyle(
                                                        color: Style.textColor(
                                                            context))),
                                                trailing: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: ccEmailList.contains(
                                                          staffList[index]
                                                              .email)
                                                      ? Icon(
                                                          CupertinoIcons
                                                              .check_mark_circled_solid,
                                                          color: CupertinoColors
                                                              .activeBlue,
                                                        )
                                                      : Icon(
                                                          CupertinoIcons
                                                              .add_circled,
                                                          color:
                                                              Style.textColor(
                                                                  context),
                                                        ),
                                                  onPressed: () {
                                                    if (!ccEmailList.contains(
                                                        staffList[index]
                                                            .email)) {
                                                      ccEmailList.add(
                                                          staffList[index]
                                                              .email);
                                                    } else {
                                                      ccEmailList.remove(
                                                          staffList[index]
                                                              .email);
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return CupertinoActivityIndicator();
                                      }
                                    }),
                              ),
                            ),

                            // Close the modal
                            CupertinoButton(
                              child: Text('Continua'),
                              onPressed: () => {
                                setState(() {
                                  selectedName = true;
                                })
                              },
                            )
                          ],
                        ),
                      ),
          ),
        );
      } else {
        EasyLoading.showToast(
            'Per procedere devi per forza accedere con il tuo Account Google',
            duration: Duration(seconds: 4),
            dismissOnTap: false,
            toastPosition: EasyLoadingToastPosition.bottom);
      }*/
    } else {
      EasyLoading.showToast(
          widget.userData.role == Role.volunteer &&
                  widget.userData.uid != widget.speaker.uidCreator
              ? 'I volontari non possono creare eventi'
              : 'Email speaker non valida, modifica e riprova.',
          duration: const Duration(seconds: 2),
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}
