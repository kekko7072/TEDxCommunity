import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:rxdart/rxdart.dart';

// You might want to provide this using dependency injection rather than a
// global variable.
late AudioHandler audioHandler;

/// Extension methods for our custom actions.
extension DemoAudioHandler on AudioHandler {
  Future<void> switchToHandler(int? index) async {
    if (index == null) return;
    await audioHandler
        .customAction('switchToHandler', <String, dynamic>{'index': index});
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  audioHandler = await AudioService.init(
    builder: () => TextPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CurrentUser?>.value(
      value: AuthService().user,
      initialData: CurrentUser(),
      catchError: (_, __) => null,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: App(audioHandler),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class QueueState {
  final List<MediaItem> queue;
  final MediaItem? mediaItem;

  QueueState(this.queue, this.mediaItem);
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class CustomEvent {
  final int handlerIndex;

  CustomEvent(this.handlerIndex);
}

class MainSwitchHandler extends SwitchAudioHandler {
  final List<AudioHandler> handlers;
  @override
  BehaviorSubject<dynamic> customState =
      BehaviorSubject<dynamic>.seeded(CustomEvent(0));

  MainSwitchHandler(this.handlers) : super(handlers.first) {
    // Configure the app's audio category and attributes for speech.
    AudioSession.instance.then((session) {
      session.configure(const AudioSessionConfiguration.speech());
    });
  }

  @override
  Future<dynamic> customAction(String name,
      [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'switchToHandler':
        stop();
        final index = extras!['index'] as int;
        inner = handlers[index];
        customState.add(CustomEvent(index));
        return null;
      default:
        return super.customAction(name, extras);
    }
  }
}

/// This task defines logic for speaking a sequence of numbers using
/// text-to-speech.
class TextPlayerHandler extends BaseAudioHandler with QueueHandler {
  final _tts = Tts();
  // final _sleeper = Sleeper();
  Completer<void>? _completer;
  var _index = 0;
  bool _interrupted = false;
  var _running = false;

  bool get _playing => playbackState.value.playing;

  TextPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          pause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
              play();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    // Handle unplugged headphones.
    session.becomingNoisyEventStream.listen((_) {
      if (_playing) pause();
    });
    queue.add([
      MediaItem(
        id: 'tts_speaker_list',
        album: 'Vocal Assistant',
        title: 'Lista speaker',
        artist: 'TEDxCortina',
        duration: const Duration(seconds: 1),
      )
    ]);
  }

  Future<void> run(String text) async {
    _completer = Completer<void>();
    _running = true;
    while (_running) {
      try {
        if (_playing) {
          mediaItem.add(queue.value[_index]);
          playbackState.add(playbackState.value.copyWith(
            updatePosition: Duration.zero,
            queueIndex: _index,
          ));
          AudioService.androidForceEnableMediaButtons();
          await Future.wait([
            _tts.speak(text),
            //EATER EGG
            //_tts.speak('Ciao ragazzi. Scusate se oggi non c\'ero alla riunione, ma avevo un impegno a cupertino.\n Non preoccupatevi, Da metà ottobre, farò parte anche io del team TEDxCortina. A presto!'),
            //_sleeper.sleep(const Duration(seconds: 1)),
          ]);

          if (_index + 1 < queue.value.length) {
            _index++;
          } else {
            _running = false;
          }
        } else {
          //  await _sleeper.sleep();
        }
        // ignore: empty_catches
      } on SleeperInterruptedException {
        // ignore: empty_catches
      } on TtsInterruptedException {}
    }
    _index = 0;
    mediaItem.add(queue.value[_index]);
    playbackState.add(playbackState.value.copyWith(
      updatePosition: Duration.zero,
    ));
    if (playbackState.value.processingState != AudioProcessingState.idle) {
      stop();
    }
    _completer?.complete();
    _completer = null;
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    if (_playing) return;
    final session = await AudioSession.instance;
    // flutter_tts doesn't activate the session, so we do it here. This
    // allows the app to stop other apps from playing audio while we are
    // playing audio.
    if (await session.setActive(true)) {
      // If we successfully activated the session, set the state to playing
      // and resume playback.
      playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.pause, MediaControl.stop],
        processingState: AudioProcessingState.ready,
        playing: true,
      ));
      if (_completer == null) {
        run(mediaId);
      } else {
        // _sleeper.interrupt();
      }
    }
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(
      controls: [],
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
    _running = false;
    _signal();
    // Wait for the speech to stop
    await _completer?.future;
    // Shut down this task
    await super.stop();
  }

  void _signal() {
    //_sleeper.interrupt();
    _tts.interrupt();
  }
}

/// An object that performs interruptable sleep.
class Sleeper {
  Completer<void>? _blockingCompleter;

  /// Sleep for a duration. If sleep is interrupted, a
  /// [SleeperInterruptedException] will be thrown.
  Future<void> sleep([Duration? duration]) async {
    _blockingCompleter = Completer();
    if (duration != null) {
      await Future.any<void>(
          [Future.delayed(duration), _blockingCompleter!.future]);
    } else {
      await _blockingCompleter!.future;
    }
    final interrupted = _blockingCompleter!.isCompleted;
    _blockingCompleter = null;
    if (interrupted) {
      throw SleeperInterruptedException();
    }
  }

  /// Interrupt any sleep that's underway.
  void interrupt() {
    if (_blockingCompleter?.isCompleted == false) {
      _blockingCompleter!.complete();
    }
  }
}

class SleeperInterruptedException {}

/// A wrapper around FlutterTts that makes it easier to wait for speech to
/// complete.
class Tts {
  final FlutterTts _flutterTts = FlutterTts();
  Completer<void>? _speechCompleter;
  bool _interruptRequested = false;
  bool _playing = false;

  Tts() {
    _flutterTts.setCompletionHandler(() {
      _speechCompleter?.complete();
    });
  }

  bool get playing => _playing;

  Future<void> speak(String text) async {
    _playing = true;
    if (!_interruptRequested) {
      _speechCompleter = Completer();
      await _flutterTts.speak(text);
      await _speechCompleter!.future;
      _speechCompleter = null;
    }
    _playing = false;
    if (_interruptRequested) {
      _interruptRequested = false;
      throw TtsInterruptedException();
    }
  }

  Future<void> stop() async {
    if (_playing) {
      await _flutterTts.stop();
      _speechCompleter?.complete();
    }
  }

  void interrupt() {
    if (_playing) {
      _interruptRequested = true;
      stop();
    }
  }
}

class TtsInterruptedException {}
