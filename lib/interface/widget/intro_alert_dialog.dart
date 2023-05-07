import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class IntroAlertDialog extends StatefulWidget {
  const IntroAlertDialog({Key? key}) : super(key: key);

  @override
  State<IntroAlertDialog> createState() => _IntroAlertDialogState();
}

class _IntroAlertDialogState extends State<IntroAlertDialog> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/tedxcommunity.appspot.com/o/video.mp4?alt=media&token=0b16e912-32aa-402c-bf23-0b17cc5f820f')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 8,
                horizontal: MediaQuery.of(context).size.width / 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CupertinoPageScaffold(
                resizeToAvoidBottomInset: false,
                navigationBar: CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  middle: Text(
                      AppLocalizations.of(context)!.welcomeToTEDxCommunity),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 25),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onDoubleTap: () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            },
                            onTap: () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: _controller.value.isInitialized
                                ? VideoPlayer(_controller)
                                : Container(),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Visibility(
                              visible: !_controller.value.isPlaying,
                              child: Center(
                                child: CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.play_circle_fill,
                                    color: Style.primaryColor,
                                    size: 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: StreamBuilder<Duration?>(
                                stream: _controller.position.asStream(),
                                builder: (context, snapshot) {
                                  return Visibility(
                                    visible: !_controller.value.isPlaying ||
                                        _controller.value.isPlaying &&
                                            (snapshot.data?.inSeconds ?? 0) < 5,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        await launchUrlString(
                                            'https://dalcantonandrea.myportfolio.com/');
                                      },
                                      child: Card(
                                          color: Style.primaryColor
                                              .withOpacity(0.8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'video by\nAndrea Dal Canton',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[200]),
                                            ),
                                          )),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _controller.value.isPlaying,
                      child: IconButton(
                          onPressed: () => _controller.pause(),
                          icon: Icon(
                            CupertinoIcons.stop_circle_fill,
                            color: Style.primaryColor,
                          )),
                    ),
                    Text(
                      AppLocalizations.of(context)!.whatIsTEDxCommunity,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Style.textColor(context)),
                      textAlign: TextAlign.center,
                    ),
                    /* Text(AppLocalizations.of(context)!.learnMoreAboutTEDxCommunity),
            Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SelectableText(
                      kGitHubReadmeLink,
                      style: const TextStyle(color: CupertinoColors.link),
                      onTap: () => launchUrlString(kGitHubReadmeLink),
                    ),
            ),*/
                    const SizedBox(height: 16.0),
                    Text(
                      '${AppLocalizations.of(context)!.developedWithLoveBy} ${AppLocalizations.of(context)!.developerName}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Style.textColor(context)),
                      textAlign: TextAlign.center,
                    ),
                    CupertinoDialogAction(
                      child: Text(AppLocalizations.of(context)!.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            )));
  }
}
