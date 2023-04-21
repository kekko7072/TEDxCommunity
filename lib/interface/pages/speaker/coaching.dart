import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:tedxcommunity/services/imports.dart';

class Coaching extends StatefulWidget {
  final Speaker speakerData;
  final bool showMobileTitle;

  const Coaching(
      {super.key, required this.speakerData, required this.showMobileTitle});

  @override
  CoachingState createState() => CoachingState();
}

class CoachingState extends State<Coaching> {
  int currentCoachingStep = 0;
  List<PlatformFile>? _paths;
  bool _loadingPath = false;
  bool _loadingDone = false;

  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));

    setState(() {
      if (widget.speakerData.talkDownloadLink!.isNotEmpty) {
        _loadingDone = true;
      }
    });
  }

  Future<void> _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      FilePickerResult? picked = await FilePicker.platform.pickFiles();

      if (picked != null) {
        if (kIsWeb) {
          uploadFile(picked.files.first.bytes!, picked.files.first.extension!);
        } else {
          if (picked.files.first.path != '') {
            uploadFile(await File(picked.files.first.path!).readAsBytes(),
                picked.files.first.extension!);
          } else {
            print('PATH FILE NULL!');
          }
        }
      } else {
        setState(() => _loadingPath = false);
      }
    } on PlatformException catch (e) {
      debugPrint('ERROR Unsupported operation$e');
    } catch (ex) {
      debugPrint('EX ERROR$ex');
    }
  }

  Future<void> uploadFile(Uint8List data, String extension) async {
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref('$licenseId/talks/${widget.speakerData.id}.$extension');
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(data);

    String url = await uploadTask.ref.getDownloadURL();

    await DatabaseSpeaker(licenseId: licenseId, id: widget.speakerData.id)
        .editTalkDownloadLink(link: url);
    if (uploadTask.state == firebase_storage.TaskState.success) {
      setState(() {
        _loadingPath = false;
        _loadingDone = true;
      });
    } else {
      print(uploadTask.state);
      setState(() {
        _loadingPath = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Speaker>(
        stream: DatabaseSpeaker(licenseId: licenseId, id: widget.speakerData.id)
            .speakerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Speaker speakerStreamData = snapshot.data!;

            currentCoachingStep = speakerStreamData.coachingStep - 1;
            CupertinoStepper buildCoachingStepper(StepperType type) {
              return CupertinoStepper(
                type: type,
                currentStep: currentCoachingStep,
                steps: [
                  buildCoachingStep(
                      title: StepService(context).loadStepCoachingTitle(1),
                      subtitle: currentCoachingStep > 0
                          ? AppLocalizations.of(context)!.completed
                          : currentCoachingStep == 0
                              ? AppLocalizations.of(context)!.inProgress
                              : AppLocalizations.of(context)!.toDo,
                      state: currentCoachingStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: false,
                      content: speakerStreamData.coachingStepDate.isNotEmpty
                          ? '${AppLocalizations.of(context)!.meetWillTakePlaceAt}  ${DateFormat('kk:mm  dd-MM-yyyy').format(DateTime.parse(speakerStreamData.coachingStepDate))} .'
                          : AppLocalizations.of(context)!
                              .dateToBeDecidedWithCoach),
                  buildCoachingStep(
                      title: StepService(context).loadStepCoachingTitle(2),
                      subtitle: currentCoachingStep > 1 || _loadingDone
                          ? AppLocalizations.of(context)!.completed
                          : currentCoachingStep == 1
                              ? AppLocalizations.of(context)!.inProgress
                              : AppLocalizations.of(context)!.toDo,
                      state: currentCoachingStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: true,
                      content: _loadingDone
                          ? AppLocalizations.of(context)!
                              .coachWillViewTextOfYourTalk
                          : AppLocalizations.of(context)!
                              .uploadATextFileContainingYourTalk),
                  buildCoachingStep(
                      title: StepService(context).loadStepCoachingTitle(3),
                      subtitle: currentCoachingStep > 2
                          ? AppLocalizations.of(context)!.completed
                          : currentCoachingStep == 2
                              ? AppLocalizations.of(context)!.inProgress
                              : AppLocalizations.of(context)!.toDo,
                      state: currentCoachingStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: false,
                      content: speakerStreamData.coachingStepDate.isNotEmpty
                          ? '${AppLocalizations.of(context)!.meetWillTakePlaceAt}  ${DateFormat('kk:mm  dd-MM-yyyy').format(DateTime.parse(speakerStreamData.coachingStepDate))} .'
                          : AppLocalizations.of(context)!
                              .dateToBeDecidedWithCoach),
                  buildCoachingStep(
                      title: StepService(context).loadStepCoachingTitle(4),
                      subtitle: currentCoachingStep > 3
                          ? AppLocalizations.of(context)!.completed
                          : currentCoachingStep == 3
                              ? AppLocalizations.of(context)!.inProgress
                              : AppLocalizations.of(context)!.toDo,
                      state: currentCoachingStep >= 3
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: false,
                      content: speakerStreamData.coachingStepDate.isNotEmpty
                          ? '${AppLocalizations.of(context)!.meetWillTakePlaceAt}  ${DateFormat('kk:mm  dd-MM-yyyy').format(DateTime.parse(speakerStreamData.coachingStepDate))} .'
                          : AppLocalizations.of(context)!
                              .dateToBeDecidedWithCoach),
                ],
              );
            }

            return CustomScrollView(
              slivers: <Widget>[
                if (widget.showMobileTitle) ...[
                  TopBarSpeaker(
                      speakerData: speakerStreamData,
                      title: AppLocalizations.of(context)!.account),
                ],
                SliverFillRemaining(
                  child: buildCoachingStepper(StepperType.vertical),
                )
              ],
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        });
  }

  Step buildCoachingStep({
    required String title,
    required String subtitle,
    StepState state = StepState.indexed,
    required String content,
    required bool showButtonUpload,
  }) {
    return Step(
      title: Text(title),
      subtitle: Text(subtitle),
      state: state,
      //isActive: false,
      content: Column(
        children: [
          Text(
            content,
            style: kSpeakerDescriptionStyle,
          ),
          showButtonUpload
              ? Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            _loadingDone
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CupertinoButton(
                                        onPressed: () => _openFileExplorer(),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .uploadNew,
                                          style: const TextStyle(
                                              color: CupertinoColors
                                                  .destructiveRed),
                                        ),
                                      ),
                                      CupertinoButton(
                                        onPressed: () async {
                                          if (await canLaunchUrlString(widget
                                              .speakerData.talkDownloadLink!)) {
                                            await launchUrlString(
                                              widget.speakerData
                                                  .talkDownloadLink!,
                                            );
                                          } else {
                                            throw 'Could not launch the url';
                                          }
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .download),
                                      ),
                                    ],
                                  )
                                : CupertinoButton(
                                    onPressed: () => _openFileExplorer(),
                                    child: CupertinoButton(
                                      onPressed: () => _openFileExplorer(),
                                      child: Text(
                                          AppLocalizations.of(context)!.upload),
                                    ),
                                  ),
                            _paths != null
                                ? Text(AppLocalizations.of(context)!.uploadDone)
                                : const SizedBox(),
                          ],
                        ),
                )
              : Container()
        ],
      ),
    );
  }
}
