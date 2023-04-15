import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class EndCoachingOrManagement extends StatefulWidget {
  final bool isCoaching;
  final Function onPressedEdit;

  const EndCoachingOrManagement(
      {super.key, required this.isCoaching, required this.onPressedEdit});

  @override
  State<EndCoachingOrManagement> createState() =>
      _EndCoachingOrManagementState();
}

class _EndCoachingOrManagementState extends State<EndCoachingOrManagement> {
  String licenseId = "NO_ID";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.isCoaching ? 'Coaching finito' : 'Gestione finita',
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        Text(
          widget.isCoaching
              ? 'Lo speaker è pronto per l\'evento.'
              : 'La gestione di questo speaker è completa.',
          style: kSpeakerTitleStyle.copyWith(
              color: CupertinoDynamicColor.resolve(
                  const CupertinoDynamicColor.withBrightness(
                    color: Color.fromRGBO(0, 0, 0, 0.8),
                    darkColor: kColorWhite,
                    //darkColor: Color(0xBF1E1E1E),
                  ),
                  context)),
        ),
        CupertinoButton(
          child: Text(
            'Modifica',
            style: CupertinoTheme.of(context)
                .textTheme
                .actionTextStyle
                .copyWith(color: CupertinoColors.destructiveRed),
          ),
          onPressed: () => widget.onPressedEdit(),
        )
      ],
    ));
  }
}

///Management

Step buildManagementStep({
  required String title,
  required String subtitle,
  StepState state = StepState.indexed,
  required String content,
}) {
  return Step(
    title: Text(title),
    subtitle: Text(subtitle),
    state: state,
    //isActive: isActive,
    content: Center(
      child: Text(
        content,
        style: kSpeakerDescriptionStyle,
      ),
    ),
  );
}

class ManagementData extends StatelessWidget {
  final Speaker speaker;

  const ManagementData({super.key, required this.speaker});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: CupertinoColors.activeBlue, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informazioni personali',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle
                        .copyWith(
                          color: CupertinoColors.activeBlue,
                        ),
                  ),
                  Text(
                    speaker.name,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.email,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.company!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.job!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.description,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.instagram!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.facebook!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.linkedin!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.dressSize!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      if (await canLaunchUrlString(speaker.urlReleaseForm!)) {
                        await launchUrlString(
                          speaker.urlReleaseForm!,
                        );
                      } else {
                        throw 'Could not launch the url';
                      }
                    },
                    child: Text(
                      "Scarica liberatoria",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: CupertinoColors.activeBlue, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hotel e Logistica',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle
                        .copyWith(
                          color: CupertinoColors.activeBlue,
                        ),
                  ),
                  Text(
                    speaker.checkInDate!.isEmpty ? 'ND' : speaker.checkInDate!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.departureDate!.isEmpty
                        ? 'ND'
                        : speaker.departureDate!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.roomType!.isEmpty ? 'ND' : speaker.roomType!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                  Text(
                    speaker.companions!.toString(),
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                          color: CupertinoColors.inactiveGray,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

///Coaching

Step buildCoachingStep({
  required BuildContext context,
  required String licenseId,
  required String speakerID,
  required String title,
  required String subtitle,
  StepState state = StepState.indexed,
  required String content,
  required bool showButton,
  required bool showGoogleSignInButton,
  required bool dateIsSelected,
  String? linkVideoCall,
  String? buttonText,
  void Function()? buttonAction,
}) {
  String linkVideoCall0 = "";
  bool selectedIndexValue = true;

  ///TODO va sistemata la modifica del link dello spekaer e sistemata meglio l'aggiunta del link

  return Step(
    title: Text(title),
    subtitle: Text(subtitle),
    state: state,
    //isActive: isActive,
    content: StatefulBuilder(
      builder:
          (BuildContext context, void Function(void Function()) setState) =>
              Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: kSpeakerDescriptionStyle,
          ),
          if (dateIsSelected) ...[
            const SizedBox(height: 10),
            CupertinoButton.filled(
              onPressed: () async {
                if (linkVideoCall != null) {
                  if (await canLaunchUrlString(linkVideoCall)) {
                    EasyLoading.showToast('Apro videochiamata',
                        duration: const Duration(seconds: 2),
                        dismissOnTap: true,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    await launchUrlString(
                      linkVideoCall,
                    );
                  }
                } else {
                  EasyLoading.showToast('Errore',
                      duration: Duration(seconds: 2),
                      dismissOnTap: true,
                      toastPosition: EasyLoadingToastPosition.bottom);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.video_camera_solid,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Partecipa',
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(height: 10),
            CupertinoSegmentedControl(
              borderColor: Style.primaryColor,
              selectedColor: Style.primaryColor,
              unselectedColor: Style.backgroundColor(context),
              children: {
                true: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Link manuale',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                false: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Calendar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              },
              groupValue: selectedIndexValue,
              onValueChanged: (bool value) {
                selectedIndexValue = value;
              },
            ),
            if (selectedIndexValue) ...[
              SizedBox(height: 10),
              CupertinoTextField(
                placeholder: 'https://meet.com/love-TEDxCortina',
                onChanged: (value) => linkVideoCall0 = value,
              ),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                onPressed: () async {
                  if (linkVideoCall0 != '') {
                    await DatabaseSpeaker(licenseId: licenseId, id: speakerID)
                        .updateCoachingStepDate(
                            date: DateTime.now().toIso8601String());
                    await DatabaseSpeaker(licenseId: licenseId, id: speakerID)
                        .editSpeakerLinkAndEventID(
                            link: linkVideoCall0, eventId: '');
                    EasyLoading.showToast('Link aggiunto correttamente',
                        duration: Duration(milliseconds: kDurationToast),
                        dismissOnTap: true,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    Navigator.of(context).pop();
                  } else {
                    EasyLoading.showToast('Aggiungi un link per procedere',
                        duration: const Duration(seconds: 3),
                        dismissOnTap: true,
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.video_camera_solid),
                    const SizedBox(width: 10),
                    Text(
                      'Aggiungi link',
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: buttonAction!,
                ),
              )
            ],
          ],
          if (!showGoogleSignInButton && showButton) ...[
            CupertinoButton(
              onPressed: buttonAction!,
              child: Text(
                buttonText!,
                style: TextStyle(
                    color: dateIsSelected
                        ? CupertinoColors.destructiveRed
                        : CupertinoColors.activeBlue),
              ),
            )
          ]
        ],
      ),
    ),
  );
}
