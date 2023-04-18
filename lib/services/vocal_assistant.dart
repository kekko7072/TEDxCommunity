import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class VocalAssistant extends StatefulWidget {
  const VocalAssistant({Key? key, required this.onCompleted}) : super(key: key);
  final Function(String value) onCompleted;

  @override
  VocalAssistantState createState() => VocalAssistantState();
}

class VocalAssistantState extends State<VocalAssistant> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech().whenComplete(() => _startListening());
  }

  @override
  void dispose() {
    super.dispose();
    _stopListening();
  }

  /// This has to happen only once per app
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    /* List<LocaleName> locales = await _speechToText.locales();
    LocaleName selectedLocale = locales[1];
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('Seleziona lingua'),
              content: SizedBox(
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: locales.length,
                    itemBuilder: (context, index) => TextButton(
                        onPressed: () {
                          selectedLocale = locales[index];
                          print(locales[index].localeId);
                          Navigator.of(context).pop();
                        },
                        child: Text(locales[index].name))),
              ),
            ));*/

    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'it-IT');
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> _stopListening() async {
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  CupertinoAlertDialog build(BuildContext context) {
    return CupertinoAlertDialog(
      title: SiriWave(
        controller: SiriWaveController(
          amplitude: 1,
          color: Style.primaryColor,
        ),
        options: const SiriWaveOptions(
          height: 100,
          backgroundColor: Colors.transparent,
        ),
        style: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .platformBrightness ==
                Brightness.dark
            ? SiriWaveStyle.ios_9
            : SiriWaveStyle.ios_7,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              // If listening is active show the recognized words
              _speechToText.isListening || _lastWords.isNotEmpty
                  ? _lastWords
                  // If listening isn't active but could be tell the user
                  // how to start it, otherwise indicate that speech
                  // recognition is not yet ready or not supported on
                  // the target device
                  : _speechEnabled
                      ? 'Inizia a parlare...'
                      : 'Speech not available',
            ),
          ),
          /*   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed:
                    // If not yet listening for speech start, otherwise stop
                    _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                tooltip: 'Listen',
                child: Icon(_speechToText.isNotListening
                    ? CupertinoIcons.mic_off
                    : CupertinoIcons.mic),
              ),
              FloatingActionButton(
                onPressed: () {
                  widget.onCompleted(_lastWords);
                  Navigator.of(context).pop();
                },
                tooltip: 'Salva',
                child: Icon(CupertinoIcons.check_mark_circled_solid),
              ),
            ],
          )*/
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            _stopListening();
            widget.onCompleted(_lastWords);
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.save),
        )
      ],
    );
  }
}

class VocalAssistantSpeaker extends StatefulWidget {
  const VocalAssistantSpeaker(
      {Key? key,
      required this.userData,
      required this.speakers,
      required this.audioHandler})
      : super(key: key);

  final UserData userData;
  final List<Speaker> speakers;
  final AudioHandler audioHandler;

  @override
  State<VocalAssistantSpeaker> createState() => _VocalAssistantSpeakerState();
}

class _VocalAssistantSpeakerState extends State<VocalAssistantSpeaker> {
  @override
  void initState() {
    super.initState();
    widget.audioHandler.playFromMediaId(speakValue());
  }

  @override
  void dispose() {
    super.dispose();
    widget.audioHandler.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await widget.audioHandler.stop();
        return true;
      },
      child: StreamBuilder<bool>(
          stream: widget.audioHandler.playbackState
              .map((state) => state.playing)
              .distinct(),
          builder: (context, snapshot) {
            final playing = snapshot.data ?? false;
            return playing
                ? SiriWave(
                    controller: SiriWaveController(
                        amplitude: 1, color: Style.primaryColor),
                    options: SiriWaveOptions(
                      backgroundColor: Style.menuColor(context),
                    ),
                    style: MediaQueryData.fromWindow(
                                    WidgetsBinding.instance.window)
                                .platformBrightness ==
                            Brightness.dark
                        ? SiriWaveStyle.ios_9
                        : SiriWaveStyle.ios_7,
                  )
                : Container(
                    color: Style.menuColor(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 40),
                      child: CupertinoButton.filled(
                          child: Text(AppLocalizations.of(context)!.cancel),
                          onPressed: () => Navigator.of(context).pop()),
                    ),
                  );
          }),
    );
  }

  String speakValue() {
    String output = "Ciao ${widget.userData.name}, ecco la lista speaker.\n";
    int i = 0;

    for (var element in widget.speakers) {
      ///Name
      output = '$output.\n ${++i}.\n ${element.name}';

      ///Profession
      if (element.description.contains(TextLabels.kAddSpeaker0) &&
          element.description.contains(TextLabels.kAddSpeaker1)) {
        int startIndexProfession =
            element.description.indexOf(TextLabels.kAddSpeaker0);
        int endIndexProfession = element.description.indexOf(
            TextLabels.kAddSpeaker1,
            startIndexProfession + TextLabels.kAddSpeaker0.length);

        output =
            '$output.\n Professione.\n ${element.description.substring(startIndexProfession + TextLabels.kAddSpeaker0.length, endIndexProfession)}';
      }

      ///TOPIC
      if (element.description.contains(TextLabels.kAddSpeaker1) &&
          element.description.contains(TextLabels.kAddSpeaker2)) {
        int startIndexTopic =
            element.description.indexOf(TextLabels.kAddSpeaker1);
        int endIndexTopic = element.description.indexOf(TextLabels.kAddSpeaker2,
            startIndexTopic + TextLabels.kAddSpeaker1.length);

        output =
            '$output.\n Topic.\n  ${element.description.substring(startIndexTopic + TextLabels.kAddSpeaker1.length, endIndexTopic)}';
      }

      ///JustTEDx
      if (element.description.contains(TextLabels.kAddSpeaker3) &&
          element.description.contains(TextLabels.kAddSpeaker4)) {
        int startIndexJustTEDx =
            element.description.indexOf(TextLabels.kAddSpeaker3);
        int endIndexJustTEDx = element.description.indexOf(
            TextLabels.kAddSpeaker4,
            startIndexJustTEDx + TextLabels.kAddSpeaker3.length);
        output =
            '$output.\n Ha già fatto un ted?.\n ${element.description.substring(startIndexJustTEDx + TextLabels.kAddSpeaker3.length, endIndexJustTEDx)}';
      }

      ///Bio
      if (element.description.contains(TextLabels.kAddSpeaker4)) {
        int startIndexBio =
            element.description.indexOf(TextLabels.kAddSpeaker4);
        output =
            '$output.\n Biografia.\n ${element.description.substring(startIndexBio + TextLabels.kAddSpeaker4.length, element.description.length)}.';
      }
    }

    return output;
  }
}
