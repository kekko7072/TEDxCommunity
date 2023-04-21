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
  String licenseId = 'NO_ID';

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
          widget.isCoaching
              ? AppLocalizations.of(context)!.coachingEnded
              : AppLocalizations.of(context)!.managementEnded,
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        Text(
          widget.isCoaching
              ? AppLocalizations.of(context)!.speakerIsReadyForEvent
              : AppLocalizations.of(context)!.managementHasBeenCompleted,
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
            AppLocalizations.of(context)!.edit,
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
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: CupertinoColors.activeBlue, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.data,
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
                    child:
                        Text(AppLocalizations.of(context)!.downloadReleaseForm),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: CupertinoColors.activeBlue, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.hotelAndLogistics,
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
  required bool dateIsSelected,
  String? linkVideoCall,
  String? buttonText,
  void Function()? buttonAction,
}) {
  String linkVideoCall0 = '';
  bool selectedIndexValue = true;

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
                    EasyLoading.showToast(
                        AppLocalizations.of(context)!.openingLinkVideoCall,
                        duration: const Duration(seconds: 2),
                        dismissOnTap: true,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    await launchUrlString(
                      linkVideoCall,
                    );
                  }
                } else {
                  EasyLoading.showToast('Error',
                      duration: const Duration(seconds: 2),
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
                    AppLocalizations.of(context)!.openLink,
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            CupertinoSegmentedControl(
              borderColor: Style.primaryColor,
              selectedColor: Style.primaryColor,
              unselectedColor: Style.backgroundColor(context),
              children: {
                true: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.linkVideoCall,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              },
              groupValue: selectedIndexValue,
              onValueChanged: (bool value) {
                selectedIndexValue = value;
              },
            ),
            if (selectedIndexValue) ...[
              const SizedBox(height: 10),
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
                            link: linkVideoCall0, eventId: '')
                        .whenComplete(() {
                      EasyLoading.showToast(
                          AppLocalizations.of(context)!.completed,
                          duration:
                              const Duration(milliseconds: kDurationToast),
                          dismissOnTap: true,
                          toastPosition: EasyLoadingToastPosition.bottom);
                      Navigator.of(context).pop();
                    });
                  } else {
                    EasyLoading.showToast(AppLocalizations.of(context)!.addLink,
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
                      AppLocalizations.of(context)!.addLink,
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
          if (showButton) ...[
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
