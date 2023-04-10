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

  String licenseId = "";
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

  void _openFileExplorer() async {
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
      print("ERROR Unsupported operation" + e.toString());
    } catch (ex) {
      print('EX ERROR' + ex.toString());
    }
  }

  Future<void> uploadFile(Uint8List _data, String extension) async {
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref('talks/${widget.speakerData.id}.$extension');
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

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
                      title: StepService.loadStepCoachingTitle(1),
                      subtitle: currentCoachingStep > 0
                          ? 'Completato'
                          : currentCoachingStep == 0
                              ? 'In corso'
                              : 'Da fare',
                      state: currentCoachingStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: false,
                      content: speakerStreamData.coachingStepDate.isNotEmpty
                          ? 'L\'incontro si svolgerà alle  ${DateFormat('kk:mm  dd-MM-yyyy').format(DateTime.parse(speakerStreamData.coachingStepDate))} .'
                          : 'Data da decidere con il coach.'),
                  buildCoachingStep(
                      title: StepService.loadStepCoachingTitle(2),
                      subtitle: currentCoachingStep > 1 || _loadingDone
                          ? 'Completato'
                          : currentCoachingStep == 1
                              ? 'In corso'
                              : 'Da fare',
                      state: currentCoachingStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: true,
                      content: _loadingDone
                          ? 'Il coach visionerà il testo del tuo talk.'
                          : 'Carica un file di testo contentente il tuo talk.'),
                  buildCoachingStep(
                      title: StepService.loadStepCoachingTitle(3),
                      subtitle: currentCoachingStep > 2
                          ? 'Completato'
                          : currentCoachingStep == 2
                              ? 'In corso'
                              : 'Da fare',
                      state: currentCoachingStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: false,
                      content: speakerStreamData.coachingStepDate.isNotEmpty
                          ? 'L\'incontro si svolgerà alle  ${DateFormat('kk:mm  dd-MM-yyyy').format(DateTime.parse(speakerStreamData.coachingStepDate))} .'
                          : 'Data da decidere con il coach.'),
                  buildCoachingStep(
                      title: StepService.loadStepCoachingTitle(4),
                      subtitle: currentCoachingStep > 3
                          ? 'Completato'
                          : currentCoachingStep == 3
                              ? 'In corso'
                              : 'Da fare',
                      state: currentCoachingStep >= 3
                          ? StepState.complete
                          : StepState.disabled,
                      showButtonUpload: false,
                      content: speakerStreamData.coachingStepDate.isNotEmpty
                          ? 'L\'incontro si svolgerà alle  ${DateFormat('kk:mm  dd-MM-yyyy').format(DateTime.parse(speakerStreamData.coachingStepDate))} .'
                          : 'Data da decidere con il coach.'),
                ],
              );
            }

            return CustomScrollView(
              slivers: <Widget>[
                if (widget.showMobileTitle) ...[
                  TopBarSpeaker(
                      speakerData: speakerStreamData, title: 'Account'),
                ],
                SliverFillRemaining(
                  child: buildCoachingStepper(StepperType.vertical),
                )
              ],
            );
          } else {
            return CupertinoActivityIndicator();
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
                      ? Padding(
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
                                          "Carica nuovo",
                                          style: TextStyle(
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
                                          "Scarica",
                                        ),
                                      ),
                                    ],
                                  )
                                : CupertinoButton(
                                    onPressed: () => _openFileExplorer(),
                                    child: CupertinoButton(
                                      onPressed: () => _openFileExplorer(),
                                      child: Text("Carica"),
                                    ),
                                  ),
                            _paths != null
                                ? Text('Caricamento fatto')
                                : SizedBox(),
                          ],
                        ),
                )
              : Container()
        ],
      ),
    );
  }
}
